import '../../../../shared/dev/stimulated_latency.dart';
import '../../../../shared/data/expert_profile.dart';
import '../models/session_history_model.dart';

abstract interface class SessionHistoryRepository {
  Future<List<SessionHistoryModel>> getSessionHistory();
  Future<SessionDetailModel> getSessionDetail(
    String sessionId,
    ExpertProfile expert,
  );
  Future<void> blockClient(String clientId);
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

  @override
  Future<SessionDetailModel> getSessionDetail(
    String sessionId,
    ExpertProfile expert,
  ) async {
    await simulateNetworkLatency(duration: const Duration(milliseconds: 650));

    final SessionHistoryModel session = switch (sessionId) {
      'session-2' => SessionHistoryModel(
          id: sessionId,
          type: SessionType.chat,
          durationMinutes: 15,
          startedAt: DateTime(2026, 1, 24, 10, 30),
          earnings: 115,
        ),
      'session-4' || 'session-6' => SessionHistoryModel(
          id: sessionId,
          type: SessionType.video,
          durationMinutes: 1,
          startedAt: DateTime(2026, 1, 23, 15, 30),
          earnings: 15,
        ),
      'session-7' => SessionHistoryModel(
          id: sessionId,
          type: SessionType.voice,
          durationMinutes: 30,
          startedAt: DateTime(2026, 1, 21, 17, 45),
          earnings: 230,
        ),
      _ => SessionHistoryModel(
          id: sessionId,
          type: SessionType.voice,
          durationMinutes: 45,
          startedAt: DateTime(2026, 1, 24, 11, 30),
          earnings: 345,
        ),
    };

    return SessionDetailModel(
      session: session,
      client: const SessionPerson(
        id: 'client-vartika',
        name: 'Vartika Kaur',
        role: 'Normal User',
        avatarAsset: 'assets/images/riya.jpg',
      ),
      expert: SessionPerson(
        id: expert.id,
        name: expert.name,
        role: expert.role.label,
        avatarAsset: expert.avatarUrl,
      ),
      status: 'Completed',
      grossAmount: 480,
      tax: 48,
      platformFee: 102,
      bonus: 15,
      userConcern: 'Career growth and decision making.',
      presentingConcern: 'Anxiety and overthinking',
      homework: 'Breathing exercise 2 times a day',
      exercise: 'Deep breathing, Meditation 10 min a day.',
      attachmentName: 'Notes.pdf',
      attachmentSize: '245 KB   PDF',
      recordingDuration: '44:11   MP3',
    );
  }

  @override
  Future<void> blockClient(String clientId) {
    return simulateNetworkLatency(duration: const Duration(milliseconds: 350));
  }
}
