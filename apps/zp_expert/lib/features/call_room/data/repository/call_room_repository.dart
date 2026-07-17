import '../models/call_room_model.dart';
import '../../../../shared/data/expert_profile.dart';

abstract class CallRoomRepository {
  Future<List<CallRoomModel>> fetchReadyRooms(ExpertRole expertRole);

  Future<CallRoomModel> fetchRoom(String roomId);

  Future<void> joinRoom(String roomId);

  Future<void> leaveRoom(String roomId);

  Future<void> setMuted(String roomId, {required bool muted});

  Future<void> setSpeakerEnabled(String roomId, {required bool enabled});

  Future<void> setVideoEnabled(String roomId, {required bool enabled});
}

class StubCallRoomRepository implements CallRoomRepository {
  List<CallRoomModel> _rooms(ExpertRole expertRole) {
    final DateTime now = DateTime.now();
    if (expertRole == ExpertRole.astrologer) {
      return <CallRoomModel>[
        CallRoomModel(
          id: 'room-video-aarav',
          threadId: 'thread-astro-1',
          clientId: 'client-201',
          clientName: 'Aarav Malhotra',
          type: CallRoomType.video,
          paidMinutes: 20,
          clientPresent: false,
          readyAt: now.subtract(const Duration(minutes: 1)),
          queuePosition: 1,
        ),
        CallRoomModel(
          id: 'room-audio-ishita',
          threadId: 'thread-astro-2',
          clientId: 'client-202',
          clientName: 'Ishita Kapoor',
          type: CallRoomType.audio,
          paidMinutes: 15,
          clientPresent: true,
          readyAt: now,
          queuePosition: 2,
        ),
      ];
    }
    return <CallRoomModel>[
      CallRoomModel(
        id: 'room-video-ananya',
        threadId: 'thread-psy-1',
        clientId: 'client-101',
        clientName: 'Ananya Singh',
        type: CallRoomType.video,
        paidMinutes: 20,
        clientPresent: false,
        readyAt: now.subtract(const Duration(minutes: 1)),
        queuePosition: 1,
      ),
      CallRoomModel(
        id: 'room-audio-kabir',
        threadId: 'thread-psy-2',
        clientId: 'client-102',
        clientName: 'Kabir Shah',
        type: CallRoomType.audio,
        paidMinutes: 15,
        clientPresent: true,
        readyAt: now,
        queuePosition: 2,
      ),
    ];
  }

  @override
  Future<List<CallRoomModel>> fetchReadyRooms(
    ExpertRole expertRole,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    return _rooms(expertRole);
  }

  @override
  Future<CallRoomModel> fetchRoom(String roomId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final List<CallRoomModel> rooms = <CallRoomModel>[
      ..._rooms(ExpertRole.psychologist),
      ..._rooms(ExpertRole.astrologer),
    ];
    return rooms.firstWhere((CallRoomModel room) => room.id == roomId);
  }

  @override
  Future<void> joinRoom(String roomId) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
  }

  @override
  Future<void> leaveRoom(String roomId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
  }

  @override
  Future<void> setMuted(String roomId, {required bool muted}) async {}

  @override
  Future<void> setSpeakerEnabled(
    String roomId, {
    required bool enabled,
  }) async {}

  @override
  Future<void> setVideoEnabled(
    String roomId, {
    required bool enabled,
  }) async {}
}
