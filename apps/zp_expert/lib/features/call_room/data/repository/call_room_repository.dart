import '../../../../shared/data/expert_session_repository.dart';
import '../../../../shared/network/expert_api_client.dart';
import '../models/call_room_model.dart';

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

class ApiCallRoomRepository implements CallRoomRepository {
  ApiCallRoomRepository({
    required ExpertApiClient api,
    required ExpertSessionRepository sessions,
  })  : _api = api,
        _sessions = sessions;

  final ExpertApiClient _api;
  final ExpertSessionRepository _sessions;
  final Map<String, CallRoomModel> _rooms = <String, CallRoomModel>{};

  @override
  Future<List<CallRoomModel>> fetchActiveRooms() {
    return _sessions.authenticated<List<CallRoomModel>>(
      (String accessToken) async {
        final dynamic data = await _api.get(
          '/api/v1/experts/me/consultations/active',
          accessToken: accessToken,
        );
        final List<dynamic> values = _listFrom(data);
        final List<CallRoomModel> rooms = values
            .whereType<Map>()
            .map((Map value) =>
                CallRoomModel.fromJson(Map<String, dynamic>.from(value)))
            .toList();
        for (final CallRoomModel room in rooms) {
          _rooms[room.id] = room;
        }
        return rooms;
      },
    );
  }

  @override
  Future<CallRoomModel> fetchRoom(String roomId) async {
    return _sessions.authenticated<CallRoomModel>((String accessToken) async {
      final dynamic data = await _api.get(
        '/api/v1/consultations/$roomId',
        accessToken: accessToken,
      );
      final CallRoomModel room = _roomFrom(data);
      _rooms[room.id] = room;
      return room;
    });
  }

  @override
  Future<CallRoomModel> acceptRoom(String roomId) {
    return _sessions.authenticated<CallRoomModel>((String accessToken) async {
      final dynamic data = await _api.post(
        '/api/v1/consultations/$roomId/accept',
        accessToken: accessToken,
      );
      final CallRoomModel room = _roomFrom(data);
      _rooms[room.id] = room;
      return room;
    });
  }

  @override
  Future<void> declineRoom(String roomId) {
    return _sessions.authenticated<void>((String accessToken) async {
      await _api.post(
        '/api/v1/consultations/$roomId/decline',
        accessToken: accessToken,
      );
      _rooms.remove(roomId);
    });
  }

  @override
  Future<AgoraCredentials> fetchAgoraCredentials(String roomId) {
    return _sessions.authenticated<AgoraCredentials>(
      (String accessToken) async {
        final dynamic data = await _api.post(
          '/api/v1/consultations/$roomId/agora-credentials',
          accessToken: accessToken,
        );
        return AgoraCredentials.fromJson(
            Map<String, dynamic>.from(data as Map));
      },
    );
  }

  @override
  Future<void> endRoom(String roomId) {
    return _sessions.authenticated<void>((String accessToken) async {
      await _api.post(
        '/api/v1/consultations/$roomId/end',
        accessToken: accessToken,
        body: const <String, dynamic>{'reason': 'participant_ended'},
      );
    });
  }

  @override
  Future<void> recordCallEvent(String roomId, String eventType) {
    return _sessions.authenticated<void>((String accessToken) async {
      await _api.post(
        '/api/v1/consultations/$roomId/call-events',
        accessToken: accessToken,
        body: <String, dynamic>{
          'eventType': eventType,
          'occurredAt': DateTime.now().toUtc().toIso8601String(),
        },
      );
    });
  }

  @override
  Stream<ConsultationEvent> watchEvents() async* {
    final String accessToken =
        (await _sessions.getOrCreateSession()).accessToken;
    try {
      await for (final ExpertSseEvent event
          in _api.events(accessToken: accessToken)) {
        if (!event.name.startsWith('consultation.')) continue;
        final dynamic rawConsultation =
            event.data['consultation'] ?? event.data;
        if (rawConsultation is! Map) continue;
        final CallRoomModel room =
            CallRoomModel.fromJson(Map<String, dynamic>.from(rawConsultation));
        _rooms[room.id] = room;
        yield ConsultationEvent(
          type: switch (event.name) {
            'consultation.requested' => ConsultationEventType.requested,
            'consultation.live' => ConsultationEventType.live,
            'consultation.ended' => ConsultationEventType.ended,
            _ => ConsultationEventType.other,
          },
          room: room,
        );
      }
    } on ExpertApiException catch (error) {
      if (error.statusCode == 401) await _sessions.clearSession();
      rethrow;
    }
  }

  CallRoomModel _roomFrom(dynamic data) {
    final dynamic value = data is Map ? (data['consultation'] ?? data) : data;
    return CallRoomModel.fromJson(Map<String, dynamic>.from(value as Map));
  }

  List<dynamic> _listFrom(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      final dynamic values = data['consultations'] ?? data['items'];
      if (values is List) return values;
      if (data['consultation'] is Map) return <dynamic>[data['consultation']];
      if (data['id'] != null) return <dynamic>[data];
    }
    return const <dynamic>[];
  }
}
