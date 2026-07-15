import '../../../../shared/dev/stimulated_latency.dart';
import '../models/session_history_model.dart';

abstract interface class SessionHistoryRepository {
  Future<List<SessionHistoryModel>> getSessionHistory();
}

class StubSessionHistoryRepository implements SessionHistoryRepository {
  @override
  Future<List<SessionHistoryModel>> getSessionHistory() async {
    await simulateNetworkLatency();

    return <SessionHistoryModel>[
      SessionHistoryModel(
        id: 'session-1',
        type: SessionType.voice,
        durationMinutes: 45,
        startedAt: DateTime(2026, 1, 24, 11, 30),
        earnings: 345,
      ),
      SessionHistoryModel(
        id: 'session-2',
        type: SessionType.chat,
        durationMinutes: 15,
        startedAt: DateTime(2026, 1, 24, 10, 30),
        earnings: 115,
      ),
      SessionHistoryModel(
        id: 'session-3',
        type: SessionType.voice,
        durationMinutes: 45,
        startedAt: DateTime(2026, 1, 23, 18, 15),
        earnings: 345,
      ),
      SessionHistoryModel(
        id: 'session-4',
        type: SessionType.video,
        durationMinutes: 1,
        startedAt: DateTime(2026, 1, 23, 15, 30),
        earnings: 15,
      ),
      SessionHistoryModel(
        id: 'session-5',
        type: SessionType.voice,
        durationMinutes: 45,
        startedAt: DateTime(2026, 1, 22, 11, 30),
        earnings: 345,
      ),
      SessionHistoryModel(
        id: 'session-6',
        type: SessionType.video,
        durationMinutes: 1,
        startedAt: DateTime(2026, 1, 22, 10, 30),
        earnings: 15,
      ),
      SessionHistoryModel(
        id: 'session-7',
        type: SessionType.voice,
        durationMinutes: 30,
        startedAt: DateTime(2026, 1, 21, 17, 45),
        earnings: 230,
      ),
      SessionHistoryModel(
        id: 'session-8',
        type: SessionType.chat,
        durationMinutes: 20,
        startedAt: DateTime(2026, 1, 21, 13, 10),
        earnings: 150,
      ),
    ];
  }
}
