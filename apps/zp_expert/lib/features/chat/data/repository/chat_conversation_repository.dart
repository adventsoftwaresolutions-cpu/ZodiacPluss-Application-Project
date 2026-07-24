import '../../../../shared/data/expert_profile.dart';
import '../models/chat_conversation_model.dart';
import '../models/session_summary_model.dart';

abstract class ChatConversationRepository {
  Future<ChatConversationModel> fetchConversation({
    required String threadId,
    required ExpertRole expertRole,
  });

  Future<ChatMessageModel> sendText({
    required String threadId,
    required String text,
  });

  Future<ChatMessageModel> sendDocument({
    required String threadId,
    required String documentName,
  });

  Future<ChatMessageModel> saveSessionSummary({
    required String threadId,
    required String sessionId,
    required String userConcern,
    required String presentingConcern,
    required String summaryNote,
    required String homework,
    required List<RecommendedExercise> exercises,
    String? summaryId,
  });
}

class StubChatConversationRepository implements ChatConversationRepository {
  @override
  Future<ChatConversationModel> fetchConversation({
    required String threadId,
    required ExpertRole expertRole,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    final DateTime now = DateTime.now();
    final bool psychologist = expertRole == ExpertRole.psychologist;
    final String name =
        psychologist ? _psychologistName(threadId) : _astrologerName(threadId);
    final String concern = psychologist
        ? 'Exam-related stress and difficulty sleeping before assessments.'
        : '';
    final List<ChatMessageModel> messages = psychologist
        ? _psychologistSessionSummaries(
            threadId: threadId,
            currentSessionId: 'session-$threadId',
            userConcern: concern,
            now: now,
          )
        : <ChatMessageModel>[
            ChatMessageModel(
              id: 'message-1',
              sender: ChatMessageSender.client,
              type: ChatMessageType.text,
              text:
                  'I have shared my birth details. Can we look at career growth?',
              sentAt: now.subtract(const Duration(hours: 1, minutes: 18)),
            ),
            ChatMessageModel(
              id: 'message-2',
              sender: ChatMessageSender.expert,
              type: ChatMessageType.text,
              text:
                  'Yes. I will first study the career houses and current transit.',
              sentAt: now.subtract(const Duration(hours: 1, minutes: 12)),
            ),
            ChatMessageModel(
              id: 'message-3',
              sender: ChatMessageSender.client,
              type: ChatMessageType.text,
              text:
                  'Thank you. I would also like to understand the best timing.',
              sentAt: now.subtract(const Duration(minutes: 42)),
            ),
          ];
    return ChatConversationModel(
      threadId: threadId,
      sessionId: 'session-$threadId',
      clientId: _clientId(threadId),
      clientName: name,
      consultationLabel:
          psychologist ? 'Video consultation ended' : 'Astrology consultation',
      expertRole: expertRole,
      isOnline: true,
      userConcern: concern,
      messages: messages,
    );
  }

  List<ChatMessageModel> _psychologistSessionSummaries({
    required String threadId,
    required String currentSessionId,
    required String userConcern,
    required DateTime now,
  }) {
    final List<ChatMessageModel> summaries = <ChatMessageModel>[];

    if (threadId == 'thread-psy-1' || threadId == 'thread-psy-2') {
      summaries.addAll(<ChatMessageModel>[
        _summaryMessage(
          id: 'summary-$threadId-1',
          sessionId: 'past-session-$threadId-1',
          userConcern: userConcern,
          presentingConcern: 'Stress response around upcoming assessments.',
          summaryNote:
              'Explored grounding strategies and recognised early signs of overwhelm.',
          homework: 'Practise the five-senses grounding exercise each evening.',
          exercises: const <RecommendedExercise>[RecommendedExercise.grounding],
          createdAt: now.subtract(const Duration(days: 28)),
        ),
        _summaryMessage(
          id: 'summary-$threadId-2',
          sessionId: 'past-session-$threadId-2',
          userConcern: userConcern,
          presentingConcern: 'Sleep disruption linked to worry thoughts.',
          summaryNote:
              'Reviewed a calming pre-sleep routine and how to use a brief worry journal.',
          homework: 'Follow the wind-down routine for the next seven days.',
          exercises: const <RecommendedExercise>[
            RecommendedExercise.journaling
          ],
          createdAt: now.subtract(const Duration(days: 14)),
        ),
      ]);
    }

    if (threadId == 'thread-psy-2') {
      summaries.add(
        _summaryMessage(
          id: 'summary-$threadId-current',
          sessionId: currentSessionId,
          userConcern: userConcern,
          presentingConcern:
              'Performance anxiety with sleep disruption before examinations.',
          summaryNote:
              'We identified the worry cycle and practised slowing down anxious thoughts.',
          homework:
              'Use the worry journal for ten minutes, then follow the wind-down routine.',
          exercises: const <RecommendedExercise>[
            RecommendedExercise.boxBreathing,
            RecommendedExercise.journaling,
          ],
          createdAt: now.subtract(const Duration(minutes: 25)),
        ),
      );
    }
    return summaries;
  }

  ChatMessageModel _summaryMessage({
    required String id,
    required String sessionId,
    required String userConcern,
    required String presentingConcern,
    required String summaryNote,
    required String homework,
    required List<RecommendedExercise> exercises,
    required DateTime createdAt,
  }) {
    final SessionSummaryModel summary = SessionSummaryModel(
      id: id,
      sessionId: sessionId,
      userConcern: userConcern,
      presentingConcern: presentingConcern,
      summaryNote: summaryNote,
      homework: homework,
      exercises: exercises,
      createdAt: createdAt,
    );
    return ChatMessageModel(
      id: summary.id,
      sender: ChatMessageSender.system,
      type: ChatMessageType.sessionSummary,
      sentAt: summary.createdAt,
      summary: summary,
    );
  }

  @override
  Future<ChatMessageModel> sendText({
    required String threadId,
    required String text,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return ChatMessageModel(
      id: 'message-${DateTime.now().microsecondsSinceEpoch}',
      sender: ChatMessageSender.expert,
      type: ChatMessageType.text,
      text: text,
      sentAt: DateTime.now(),
    );
  }

  @override
  Future<ChatMessageModel> sendDocument({
    required String threadId,
    required String documentName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return ChatMessageModel(
      id: 'document-${DateTime.now().microsecondsSinceEpoch}',
      sender: ChatMessageSender.expert,
      type: ChatMessageType.document,
      documentName: documentName,
      sentAt: DateTime.now(),
    );
  }

  @override
  Future<ChatMessageModel> saveSessionSummary({
    required String threadId,
    required String sessionId,
    required String userConcern,
    required String presentingConcern,
    required String summaryNote,
    required String homework,
    required List<RecommendedExercise> exercises,
    String? summaryId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final SessionSummaryModel summary = SessionSummaryModel(
      id: summaryId ?? 'summary-$threadId',
      sessionId: sessionId,
      userConcern: userConcern,
      presentingConcern: presentingConcern,
      summaryNote: summaryNote,
      homework: homework,
      exercises: exercises,
      createdAt: DateTime.now(),
    );
    return ChatMessageModel(
      id: summary.id,
      sender: ChatMessageSender.system,
      type: ChatMessageType.sessionSummary,
      sentAt: summary.createdAt,
      summary: summary,
    );
  }

  String _psychologistName(String threadId) =>
      <String, String>{
        'thread-psy-1': 'Ananya Singh',
        'thread-psy-2': 'Kabir Shah',
        'thread-psy-3': 'Meera Iyer',
        'thread-psy-4': 'Rohan Mehta',
        'thread-psy-5': 'Aditya Raj',
        'thread-psy-6': 'Anurag',
      }[threadId] ??
      'Client';

  String _astrologerName(String threadId) =>
      <String, String>{
        'thread-astro-1': 'Aarav Malhotra',
        'thread-astro-2': 'Ishita Kapoor',
        'thread-astro-3': 'Dev Patel',
        'thread-astro-4': 'Neha Joshi',
      }[threadId] ??
      'Client';

  String _clientId(String threadId) =>
      <String, String>{
        'thread-psy-1': 'client-101',
        'thread-psy-2': 'client-102',
        'thread-psy-3': 'client-103',
        'thread-psy-4': 'client-104',
        'thread-psy-5': 'client-105',
        'thread-psy-6': 'client-106',
        'thread-astro-1': 'client-201',
        'thread-astro-2': 'client-202',
        'thread-astro-3': 'client-203',
        'thread-astro-4': 'client-204',
      }[threadId] ??
      'client-$threadId';
}
