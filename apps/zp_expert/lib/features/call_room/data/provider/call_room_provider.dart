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

final AsyncNotifierProvider<IncomingCallRoomsController, List<CallRoomModel>>
    incomingCallRoomsProvider =
    AsyncNotifierProvider<IncomingCallRoomsController, List<CallRoomModel>>(
  IncomingCallRoomsController.new,
);

class IncomingCallRoomsController extends AsyncNotifier<List<CallRoomModel>> {
  bool _disposed = false;
  Timer? _reconnectTimer;
  Completer<void>? _reconnectCompleter;

  @override
  Future<List<CallRoomModel>> build() async {
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _reconnectTimer?.cancel();
      final Completer<void>? completer = _reconnectCompleter;
      if (completer != null && !completer.isCompleted) completer.complete();
    });
    final CallRoomRepository repository = ref.watch(callRoomRepositoryProvider);
    final List<CallRoomModel> active = await repository.fetchActiveRooms();
    unawaited(_listen(repository));
    return active;
  }

  Future<void> _listen(CallRoomRepository repository) async {
    while (!_disposed) {
      try {
        final List<CallRoomModel> active = await repository.fetchActiveRooms();
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
            current.add(event.room);
            current.sort((CallRoomModel a, CallRoomModel b) =>
                a.readyAt.compareTo(b.readyAt));
          }
          state = AsyncData<List<CallRoomModel>>(current);
        }
      } catch (_) {
        if (_disposed) return;
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
    final List<CallRoomModel>? current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData<List<CallRoomModel>>(
      current.where((CallRoomModel room) => room.id != roomId).toList(),
    );
  }

  void upsertRoom(CallRoomModel room) {
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
    await ref.read(callRoomRepositoryProvider).declineRoom(roomId);
    claimRoom(roomId);
  }

  Future<void> refresh() async {
    try {
      final List<CallRoomModel> active =
          await ref.read(callRoomRepositoryProvider).fetchActiveRooms();
      state = AsyncData<List<CallRoomModel>>(active);
    } catch (_) {
      // Keep the last known rooms visible while SSE reconnects.
    }
  }
}

final AsyncNotifierProviderFamily<CallSessionController, CallSessionState,
        String> callSessionProvider =
    AsyncNotifierProvider.family<CallSessionController, CallSessionState,
        String>(CallSessionController.new);

class CallSessionController
    extends FamilyAsyncNotifier<CallSessionState, String> {
  Timer? _timer;
  bool _joinedEventSent = false;
  CallMediaConnection? _lastMediaConnection;

  @override
  Future<CallSessionState> build(String roomId) async {
    ref.read(incomingCallRoomsProvider);
    final CallRoomRepository repository = ref.watch(callRoomRepositoryProvider);
    final CallMediaController media =
        ref.read(callMediaProvider(roomId).notifier);
    ref.onDispose(() {
      _timer?.cancel();
      unawaited(media.leave());
      unawaited(_recordBestEffort(repository, roomId, 'left'));
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
    CallRoomModel room = await repository.fetchRoom(roomId);
    ref.read(activeCallRoomIdProvider.notifier).state = roomId;
    try {
      if (!room.isLive) room = await repository.acceptRoom(roomId);
      final AgoraCredentials credentials =
          await repository.fetchAgoraCredentials(roomId);
      await media.join(credentials, video: room.type == CallRoomType.video);
    } catch (error, stackTrace) {
      debugPrint('Unable to join consultation $roomId: $error');
      debugPrintStack(stackTrace: stackTrace);
      ref.read(activeCallRoomIdProvider.notifier).state = null;
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
    Future<void>.delayed(Duration.zero, _startClock);
    return initial;
  }

  void _handleMediaState(
    CallRoomRepository repository,
    CallMediaState media,
  ) {
    final CallSessionState? current = state.valueOrNull;
    if (current != null && current.phase != CallSessionPhase.ended) {
      final CallSessionPhase phase = media.remoteUid == null
          ? CallSessionPhase.waitingForClient
          : CallSessionPhase.connected;
      if (current.phase != phase) {
        state = AsyncData<CallSessionState>(current.copyWith(phase: phase));
      }
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

  void _startClock() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final CallSessionState? current = state.valueOrNull;
      if (current == null || current.phase == CallSessionPhase.ended) return;
      state = AsyncData<CallSessionState>(
        current.copyWith(elapsedSeconds: current.elapsedSeconds + 1),
      );
    });
  }

  Future<void> toggleMute() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null || current.phase == CallSessionPhase.ended) return;
    final bool requestedMuted = !current.isMuted;
    final bool actualMuted = await ref
        .read(callMediaProvider(arg).notifier)
        .setMuted(requestedMuted);
    state = AsyncData<CallSessionState>(
      current.copyWith(isMuted: actualMuted),
    );
  }

  Future<void> toggleSpeaker() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null || current.phase == CallSessionPhase.ended) return;
    final bool enabled = !current.isSpeakerOn;
    await ref.read(callMediaProvider(arg).notifier).setSpeakerEnabled(enabled);
    state = AsyncData<CallSessionState>(current.copyWith(isSpeakerOn: enabled));
  }

  Future<void> toggleVideo() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null || current.phase == CallSessionPhase.ended) return;
    final bool requestedEnabled = !current.isVideoOn;
    final bool actualEnabled = await ref
        .read(callMediaProvider(arg).notifier)
        .setVideoEnabled(requestedEnabled);
    state = AsyncData<CallSessionState>(
      current.copyWith(isVideoOn: actualEnabled),
    );
  }

  Future<void> endCall() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null || current.phase == CallSessionPhase.ended) return;
    _timer?.cancel();
    final CallRoomRepository repository = ref.read(callRoomRepositoryProvider);
    await repository.endRoom(current.room.id);
    await _finishCall(current, endedAutomatically: false);
  }

  Future<void> _endFromBackend() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null || current.phase == CallSessionPhase.ended) return;
    _timer?.cancel();
    await _finishCall(current, endedAutomatically: true);
  }

  Future<void> _finishCall(
    CallSessionState current, {
    required bool endedAutomatically,
  }) async {
    await _recordBestEffort(
      ref.read(callRoomRepositoryProvider),
      current.room.id,
      'left',
    );
    await ref.read(callMediaProvider(arg).notifier).leave();
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

  Future<void> _recordBestEffort(
    CallRoomRepository repository,
    String roomId,
    String eventType,
  ) async {
    try {
      await repository.recordCallEvent(roomId, eventType);
    } catch (_) {}
  }
}
