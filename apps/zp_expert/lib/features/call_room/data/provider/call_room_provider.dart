import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/call_room_model.dart';
import '../repository/call_room_repository.dart';
import '../../../../shared/data/expert_profile.dart';
import '../../../../shared/data/expert_profile_repository.dart';

final Provider<CallRoomRepository> callRoomRepositoryProvider =
    Provider<CallRoomRepository>((Ref ref) => StubCallRoomRepository());

final AsyncNotifierProvider<IncomingCallRoomsController, List<CallRoomModel>>
    incomingCallRoomsProvider =
    AsyncNotifierProvider<IncomingCallRoomsController, List<CallRoomModel>>(
        IncomingCallRoomsController.new);

class IncomingCallRoomsController extends AsyncNotifier<List<CallRoomModel>> {
  @override
  Future<List<CallRoomModel>> build() async {
    final ExpertProfile profile = await ref.watch(expertProfileProvider.future);
    return ref.watch(callRoomRepositoryProvider).fetchReadyRooms(profile.role);
  }

  void claimRoom(String roomId) {
    final List<CallRoomModel>? current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData<List<CallRoomModel>>(
      current.where((CallRoomModel room) => room.id != roomId).toList(),
    );
  }
}

final AsyncNotifierProviderFamily<CallSessionController, CallSessionState,
        String> callSessionProvider =
    AsyncNotifierProvider.family<CallSessionController, CallSessionState,
        String>(CallSessionController.new);

class CallSessionController
    extends FamilyAsyncNotifier<CallSessionState, String> {
  Timer? _timer;

  @override
  Future<CallSessionState> build(String roomId) async {
    ref.onDispose(() => _timer?.cancel());
    final CallRoomRepository repository = ref.watch(callRoomRepositoryProvider);
    final CallRoomModel room = await repository.fetchRoom(roomId);
    await repository.joinRoom(roomId);
    ref.read(incomingCallRoomsProvider.notifier).claimRoom(roomId);
    final CallSessionState initial = CallSessionState(
      room: room,
      phase: room.clientPresent
          ? CallSessionPhase.connected
          : CallSessionPhase.waitingForClient,
    );
    Future<void>.delayed(Duration.zero, _startClock);
    return initial;
  }

  void _startClock() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final CallSessionState? current = state.valueOrNull;
      if (current == null || current.phase == CallSessionPhase.ended) return;
      if (current.phase == CallSessionPhase.waitingForClient) {
        final int remaining = current.waitingSeconds - 1;
        if (remaining <= 0) {
          endCall(automatically: true);
        } else {
          state = AsyncData<CallSessionState>(
            current.copyWith(waitingSeconds: remaining),
          );
        }
        return;
      }
      state = AsyncData<CallSessionState>(
        current.copyWith(elapsedSeconds: current.elapsedSeconds + 1),
      );
    });
  }

  Future<void> toggleMute() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null || current.phase == CallSessionPhase.ended) return;
    final bool muted = !current.isMuted;
    await ref
        .read(callRoomRepositoryProvider)
        .setMuted(current.room.id, muted: muted);
    state = AsyncData<CallSessionState>(
      current.copyWith(isMuted: muted),
    );
  }

  Future<void> toggleSpeaker() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null || current.phase == CallSessionPhase.ended) return;
    final bool enabled = !current.isSpeakerOn;
    await ref
        .read(callRoomRepositoryProvider)
        .setSpeakerEnabled(current.room.id, enabled: enabled);
    state = AsyncData<CallSessionState>(
      current.copyWith(isSpeakerOn: enabled),
    );
  }

  Future<void> toggleVideo() async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null || current.phase == CallSessionPhase.ended) return;
    final bool enabled = !current.isVideoOn;
    await ref
        .read(callRoomRepositoryProvider)
        .setVideoEnabled(current.room.id, enabled: enabled);
    state = AsyncData<CallSessionState>(
      current.copyWith(isVideoOn: enabled),
    );
  }

  Future<void> endCall({bool automatically = false}) async {
    final CallSessionState? current = state.valueOrNull;
    if (current == null || current.phase == CallSessionPhase.ended) return;
    _timer?.cancel();
    await ref.read(callRoomRepositoryProvider).leaveRoom(current.room.id);
    state = AsyncData<CallSessionState>(
      current.copyWith(
        phase: CallSessionPhase.ended,
        waitingSeconds: automatically ? 0 : current.waitingSeconds,
        endedAutomatically: automatically,
      ),
    );
  }
}
