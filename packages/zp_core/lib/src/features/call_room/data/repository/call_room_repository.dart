import '../models/call_room_model.dart';

/// Abstract interface for call room operations.
///
/// Each consuming app provides its own concrete implementation wired to
/// its own API client and session repository. The concrete implementation
/// is injected via a Riverpod provider override at the app level.
abstract class CallRoomRepository {
  Future<List<CallRoomModel>> fetchActiveRooms();
  Future<CallRoomModel> fetchRoom(String roomId);
  Future<CallRoomModel> acceptRoom(String roomId);
  Future<void> declineRoom(String roomId);
  Future<AgoraCredentials> fetchAgoraCredentials(String roomId);
  Future<void> endRoom(String roomId);
  Future<void> recordCallEvent(String roomId, String eventType);
  Stream<ConsultationEvent> watchEvents();
}
