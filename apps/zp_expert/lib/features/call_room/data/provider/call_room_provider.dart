import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/expert_profile.dart';
import '../../../../shared/data/expert_profile_repository.dart';
import '../../../../shared/data/expert_session_repository.dart';
import '../../../../shared/network/expert_api_client.dart';
import '../models/call_room_model.dart';
import '../repository/call_room_repository.dart';
import 'call_media_controller.dart';

final Provider<CallRoomRepository> callRoomRepositoryProvider =
    Provider<CallRoomRepository>((Ref ref) {
  return ApiCallRoomRepository(
    api: ref.watch(expertApiClientProvider),
    sessions: ref.watch(expertSessionRepositoryProvider),
  );
});

final StateProvider<String?> activeCallRoomIdProvider =
    StateProvider<String?>((Ref ref) => null);

final StateProvider<ConsultationEvent?> latestConsultationEventProvider =
    StateProvider<ConsultationEvent?>((Ref ref) => null);

final Provider<Duration> incomingCallPollIntervalProvider =
    Provider<Duration>((Ref ref) => const Duration(seconds: 2));

final Provider<Duration> remoteClientDisconnectGraceProvider =
    Provider<Duration>((Ref ref) => const Duration(seconds: 5));

final AsyncNotifierProvider<IncomingCallRoomsController, List<CallRoomModel>>
    incomingCallRoomsProvider =
    AsyncNotifierProvider<IncomingCallRoomsController, List<CallRoomModel>>(
  IncomingCallRoomsController.new,
);

class IncomingCallRoomsController extends AsyncNotifier<List<CallRoomModel>> {
  final Set<String> _dismissedRoomIds = <String>{};
  bool _disposed = false;
  bool _refreshing = false;
  Timer? _pollTimer;
  Timer? _reconnectTimer;
  Completer<void>? _reconnectCompleter;

  @override
  Future<List<CallRoomModel>> build() async {
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _pollTimer?.cancel();
      _reconnectTimer?.cancel();
      final Completer<void>? completer = _reconnectCompleter;
      if (completer != null && !completer.isCompleted) completer.complete();
    });
    final CallRoomRepository repository = ref.watch(callRoomRepositoryProvider);
    final List<CallRoomModel> active =
        _visible(await repository.fetchActiveRooms());
    _pollTimer = Timer.periodic(
      ref.watch(incomingCallPollIntervalProvider),
      (_) => unawaited(refresh()),
    );
    unawaited(_listen(repository));
    return active;
  }

  Future<void> _listen(CallRoomRepository repository) async {
    while (!_disposed) {
      try {
        final List<CallRoomModel> active =
            _visible(await repository.fetchActiveRooms());
        if (_disposed) return;
        state = AsyncData<List<CallRoomModel>>(active);
        await for (final ConsultationEvent event in repository.watchEvents()) {
          if (_disposed) return;
          ref.read(latestConsultationEventProvider.notifier).state = event;
          final List<CallRoomModel> current =
              List<CallRoomModel>.from(state.valueOrNull ?? active);
          current.removeWhere((CallRoomModel room) => room.id == event.room.id);
          if (event.type == ConsultationEventType.requested ||
              event.type == ConsultationEventType.live) {
            if (_isVisible(event.room)) {
              current.add(event.room);
            }
            current.sort((CallRoomModel a, CallRoomModel b) =>
                a.readyAt.compareTo(b.readyAt));
          }
          state = AsyncData<List<CallRoomModel>>(current);
        }
      } catch (error) {
        if (_disposed) return;
        debugPrint('Consultation event stream disconnected: $error');
      }
      await _waitBeforeReconnect();
    }
  }

  Future<void> _waitBeforeReconnect() {
    final Completer<void> completer = Completer<void>();
    _reconnectCompleter = completer;
    _reconnectTimer = Timer(const Duration(seconds: 2), completer.complete);
    return completer.future;
  }

  void claimRoom(String roomId) {
    _dismissedRoomIds.add(roomId);
    final List<CallRoomModel>? current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData<List<CallRoomModel>>(
      current.where((CallRoomModel room) => room.id != roomId).toList(),
    );
  }

  void upsertRoom(CallRoomModel room) {
    _dismissedRoomIds.remove(room.id);
    final List<CallRoomModel> current =
        List<CallRoomModel>.from(state.valueOrNull ?? <CallRoomModel>[]);
    current.removeWhere((CallRoomModel item) => item.id == room.id);
    current.add(room);
    current.sort(
      (CallRoomModel a, CallRoomModel b) => a.readyAt.compareTo(b.readyAt),
    );
    state = AsyncData<List<CallRoomModel>>(current);
  }

  Future<void> declineRoom(String roomId) async {
    CallRoomModel? declinedRoom;
    for (final CallRoomModel room in state.valueOrNull ?? <CallRoomModel>[]) {
      if (room.id == roomId) declinedRoom = room;
    }
    claimRoom(roomId);
    try {
      await ref.read(callRoomRepositoryProvider).declineRoom(roomId);
    } catch (_) {
      if (declinedRoom != null) upsertRoom(declinedRoom);
      rethrow;
    }
  }

  Future<void> refresh() async {
    if (_disposed || _refreshing) return;
    _refreshing = true;
    try {
      final List<CallRoomModel> active = _visible(
        await ref.read(callRoomRepositoryProvider).fetchActiveRooms(),
      );
      if (_disposed) return;
      state = AsyncData<List<CallRoomModel>>(active);
    } catch (error) {
      debugPrint('Unable to refresh active consultations: $error');
      // Keep the last known rooms visible while SSE reconnects.
    } finally {
      _refreshing = false;
    }
  }

  List<CallRoomModel> _visible(List<CallRoomModel> rooms) =>
      rooms.where(_isVisible).toList();

  bool _isVisible(CallRoomModel room) {
    if (_dismissedRoomIds.contains(room.id)) return false;
    final DateTime? expiresAt = room.requestExpiresAt;
    return room.isLive ||
        expiresAt == null ||
        expiresAt.isAfter(DateTime.now());
  }
}

final AsyncNotifierProviderFamily<CallSessionController, CallSessionState,
        String> callSessionProvider =
    AsyncNotifierProvider.family<CallSessionController, CallSessionState,
        String>(CallSessionController.new);

class CallSessionController
    extends FamilyAsyncNotifier<CallSessionState, String> {
  Timer? _clockTimer;
  Timer? _deadlineTimer;
  Timer? _remoteDisconnectTimer;
  bool _ending = false;
  bool _togglingMute = false;
  bool _togglingSpeaker = false;
  bool _togglingVideo = false;
  bool _joinedEventSent = false;
  bool _leftEventSent = false;
  CallMediaConnection? _lastMediaConnection;

  @override
  Future<CallSessionState> build(String roomId) async {
    ref.read(incomingCallRoomsProvider);
    final CallRoomRepository repository = ref.watch(callRoomRepositoryProvider);
    final CallMediaController media =
        ref.read(callMediaProvider(roomId).notifier);
    ref.onDispose(() {
      _cancelTimers();
      unawaited(media.leave());
      unawaited(_recordLeftBestEffort(repository, roomId));
    });

    ref.listen<CallMediaState>(callMediaProvider(roomId),
        (CallMediaState? previous, CallMediaState next) {
      _handleMediaState(repository, next);
    });
    ref.listen<ConsultationEvent?>(latestConsultationEventProvider,
        (ConsultationEvent? previous, ConsultationEvent? next) {
      if (next?.room.id == roomId &&
          next?.type == ConsultationEventType.ended) {
        unawaited(_endFromBackend());
      }
    });

    final ExpertProfile profile = await ref.watch(expertProfileProvider.future);
    final String? activeRoomId = ref.read(activeCallRoomIdProvider);
    if (activeRoomId != null && activeRoomId != roomId) {
      throw StateError('An active call room already exists.');
    }
    ref.read(activeCallRoomIdProvider.notifier).state = roomId;
    late CallRoomModel room;
    try {
      room = await repository.fetchRoom(roomId);
      final DateTime? expiresAt = room.requestExpiresAt;
      if (!room.isLive &&
          expiresAt != null &&
          !expiresAt.isAfter(DateTime.now())) {
        throw StateError('This consultation request has expired.');
      }
    } catch (_) {
      if (ref.read(activeCallRoomIdProvider) == roomId) {
        ref.read(activeCallRoomIdProvider.notifier).state = null;
      }
      rethrow;
    }
    try {
      if (!room.isLive) room = await repository.acceptRoom(roomId);
      final AgoraCredentials credentials =
          await repository.fetchAgoraCredentials(roomId);
      await media.join(credentials, video: room.type == CallRoomType.video);
    } catch (error, stackTrace) {
      debugPrint('Unable to join consultation $roomId: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (ref.read(activeCallRoomIdProvider) == roomId) {
        ref.read(activeCallRoomIdProvider.notifier).state = null;
      }
      await media.leave();
      unawaited(ref.read(incomingCallRoomsProvider.notifier).refresh());
      rethrow;
    }
    ref.read(incomingCallRoomsProvider.notifier).upsertRoom(room);
    final CallMediaState mediaState = ref.read(callMediaProvider(roomId));
    final CallSessionState initial = CallSessionState(
      room: room,
      expertRole: profile.role,
      phase: mediaState.remoteUid == null
          ? CallSessionPhase.waitingForClient
          : CallSessionPhase.connected,
      isMuted: !mediaState.microphoneEnabled,
      isVideoOn: room.type == CallRoomType.video && mediaState.cameraEnabled,
    );
    Future<void>.delayed(Duration.zero, () => _startTimers(initial));
    return initial;
  }

  void _handleMediaState(
    CallRoomRepository repository,
    CallMediaState media,
  ) {
    final CallSessionState? current = state.valueOrNull;
    if (current != null && current.phase != CallSessionPhase.ended) {
      if (media.connection == CallMediaConnection.ended) {
        unawaited(_endFromBackend());
        return;
      }
      final CallSessionPhase phase =
          media.connection == CallMediaConnection.reconnecting
              ? CallSessionPhase.reconnecting
              : media.remoteUid == null
                  ? CallSessionPhase.waitingForClient
                  : CallSessionPhase.connected;
      if (current.phase != phase) {
        state = AsyncData<CallSessionState>(current.copyWith(phase: phase));
      }
      _handleRemotePresence(current, media);
    }
    if (media.localJoined && !_joinedEventSent) {
      _joinedEventSent = true;
      unawaited(_recordBestEffort(repository, arg, 'joined'));
    }
    if (_lastMediaConnection != media.connection) {
      if (media.connection == CallMediaConnection.reconnecting) {
        unawaited(_recordBestEffort(repository, arg, 'reconnecting'));
      } else if (_lastMediaConnection == CallMediaConnection.reconnecting &&
          media.connection == CallMediaConnection.connected) {
        unawaited(_recordBestEffort(repository, arg, 'reconnected'));
      }
      _lastMediaConnection = media.connection;
    }
  }

  void _startTimers(CallSessionState initial) {
    if (_ending || state.valueOrNull?.phase == CallSessionPhase.ended) return;
    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final CallSessionState? current = state.valueOrNull;
      if (current == null || current.phase == CallSessionPhase.ended) return;
      state = AsyncData<CallSessionState>(
        current.copyWith(elapsedSeconds: current.elapsedSeconds + 1),
      );
    });
    final DateTime? expectedEndAt = initial.room.expectedEndAt;
    if (expectedEndAt == null) return;
    final Duration remaining = expectedEndAt.difference(DateTime.now());
    _deadlineTimer?.cancel();
    _deadlineTimer = Timer(
      remaining.isNegative ? Duration.zero : remaining,
      () => unawaited(_endFromBackend()),
    );
  }

  void _handleRemotePresence(
    CallSessionState previous,
    CallMediaState media,
  ) {
    if (media.remoteUid != null) {
      _remoteDisconnectTimer?.cancel();
      _remoteDisconnectTimer = null;
      return;
    }
    if (previous.phase != CallSessionPhase.connected ||
        _remoteDisconnectTimer != null) {
      return;
    }
    _remoteDisconnectTimer = Timer(
      ref.read(remoteClientDisconnectGraceProvider),
      () {
        _remoteDisconnectTimer = null;
        final CallMediaState latest = ref.read(callMediaProvider(arg));
        if (latest.remoteUid == null) unawaited(_endFromBackend());
      },
    );
  }

  Future<void> toggleMute() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null ||
        current.phase == CallSessionPhase.ended ||
        _togglingMute) {
      return;
    }
    _togglingMute = true;
    final bool requestedMuted = !current.isMuted;
    try {
      final bool actualMuted = await ref
          .read(callMediaProvider(arg).notifier)
          .setMuted(requestedMuted);
      final CallSessionState? latest = state.valueOrNull;
      if (latest != null && latest.phase != CallSessionPhase.ended) {
        state = AsyncData<CallSessionState>(
          latest.copyWith(isMuted: actualMuted),
        );
      }
    } catch (error) {
      debugPrint('Unable to toggle the microphone: $error');
    } finally {
      _togglingMute = false;
    }
  }

  Future<void> toggleSpeaker() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null ||
        current.phase == CallSessionPhase.ended ||
        _togglingSpeaker) {
      return;
    }
    _togglingSpeaker = true;
    final bool enabled = !current.isSpeakerOn;
    try {
      await ref
          .read(callMediaProvider(arg).notifier)
          .setSpeakerEnabled(enabled);
      final CallSessionState? latest = state.valueOrNull;
      if (latest != null && latest.phase != CallSessionPhase.ended) {
        state = AsyncData<CallSessionState>(
          latest.copyWith(isSpeakerOn: enabled),
        );
      }
    } catch (error) {
      debugPrint('Unable to change the speaker route: $error');
    } finally {
      _togglingSpeaker = false;
    }
  }

  Future<void> toggleVideo() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null ||
        current.phase == CallSessionPhase.ended ||
        _togglingVideo) {
      return;
    }
    _togglingVideo = true;
    final bool requestedEnabled = !current.isVideoOn;
    try {
      final bool actualEnabled = await ref
          .read(callMediaProvider(arg).notifier)
          .setVideoEnabled(requestedEnabled);
      final CallSessionState? latest = state.valueOrNull;
      if (latest != null && latest.phase != CallSessionPhase.ended) {
        state = AsyncData<CallSessionState>(
          latest.copyWith(isVideoOn: actualEnabled),
        );
      }
    } catch (error) {
      debugPrint('Unable to toggle the camera: $error');
    } finally {
      _togglingVideo = false;
    }
  }

  Future<void> endCall() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null || current.phase == CallSessionPhase.ended || _ending) {
      return;
    }
    _ending = true;
    _finishCallImmediately(current, endedAutomatically: false);
    final CallRoomRepository repository = ref.read(callRoomRepositoryProvider);
    await Future.wait<void>(<Future<void>>[
      _endRoomBestEffort(repository, current.room.id),
      _recordLeftBestEffort(repository, current.room.id),
      ref.read(callMediaProvider(arg).notifier).leave(),
    ]);
  }

  Future<void> _endFromBackend() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null || current.phase == CallSessionPhase.ended || _ending) {
      return;
    }
    _ending = true;
    _finishCallImmediately(current, endedAutomatically: true);
    await Future.wait<void>(<Future<void>>[
      _recordLeftBestEffort(
        ref.read(callRoomRepositoryProvider),
        current.room.id,
      ),
      ref.read(callMediaProvider(arg).notifier).leave(),
    ]);
  }

  void _finishCallImmediately(
    CallSessionState current, {
    required bool endedAutomatically,
  }) {
    _cancelTimers();
    if (ref.read(activeCallRoomIdProvider) == current.room.id) {
      ref.read(activeCallRoomIdProvider.notifier).state = null;
    }
    ref.read(incomingCallRoomsProvider.notifier).claimRoom(current.room.id);
    state = AsyncData<CallSessionState>(
      current.copyWith(
        phase: CallSessionPhase.ended,
        endedAutomatically: endedAutomatically,
      ),
    );
  }

  void _cancelTimers() {
    _clockTimer?.cancel();
    _deadlineTimer?.cancel();
    _remoteDisconnectTimer?.cancel();
    _clockTimer = null;
    _deadlineTimer = null;
    _remoteDisconnectTimer = null;
  }

  Future<void> _endRoomBestEffort(
    CallRoomRepository repository,
    String roomId,
  ) async {
    for (int attempt = 0; attempt < 2; attempt += 1) {
      try {
        await repository.endRoom(roomId);
        return;
      } catch (error) {
        debugPrint('Unable to sync ended consultation $roomId: $error');
        if (attempt == 0) {
          await Future<void>.delayed(const Duration(milliseconds: 500));
        }
      }
    }
  }

  Future<void> _recordBestEffort(
    CallRoomRepository repository,
    String roomId,
    String eventType,
  ) async {
    try {
      await repository.recordCallEvent(roomId, eventType);
    } catch (_) {}
  }

  Future<void> _recordLeftBestEffort(
    CallRoomRepository repository,
    String roomId,
  ) {
    if (_leftEventSent) return Future<void>.value();
    _leftEventSent = true;
    return _recordBestEffort(repository, roomId, 'left');
  }
}
