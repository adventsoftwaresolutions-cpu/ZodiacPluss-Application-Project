import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:zp_expert/features/chat/chat_conversation.dart';
import 'package:zp_expert/features/chat/data/models/chat_conversation_model.dart';
import 'package:zp_expert/features/chat/data/models/session_summary_model.dart';
import 'package:zp_expert/features/chat/data/provider/chat_conversation_provider.dart';
import 'package:zp_expert/features/chat/data/repository/chat_conversation_repository.dart';
import 'package:zp_expert/features/kundali/kundali.dart';
import 'package:zp_expert/navigation/app_routes.dart';
import 'package:zp_expert/shared/data/expert_profile.dart';
import 'package:zp_expert/shared/data/expert_profile_repository.dart';

void main() {
  testWidgets('psychologist can fill a session summary without chat messages',
      (WidgetTester tester) async {
    _configurePhone(tester);
    final _ConversationRepository repository = _ConversationRepository();
    await tester.pumpWidget(
      _testApp(
        role: ExpertRole.psychologist,
        repository: repository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fill session summary'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('view-kundali-banner')),
        findsNothing);
    expect(find.byKey(const ValueKey<String>('attach-document-button')),
        findsNothing);
    expect(find.byKey(const ValueKey<String>('chat-message-field')),
        findsOneWidget);
    final TextField psychologistMessageField = tester.widget<TextField>(
      find.byKey(const ValueKey<String>('chat-message-field')),
    );
    expect(psychologistMessageField.enabled, isFalse);
    expect(find.text('Messaging is unavailable for psychologists'),
        findsOneWidget);
    expect(find.text('Hello'), findsNothing);

    await tester.tap(find.text('Fill session summary'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey<String>('read-only-user-concern')),
        findsOneWidget);
    expect(find.text('Submitted during booking and cannot be edited.'),
        findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey<String>('presenting-concern-field')),
      'Performance anxiety affecting sleep.',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester
        .tap(find.byKey(const ValueKey<String>('save-session-summary')));
    await tester.pumpAndSettle();

    expect(repository.savedPresentingConcern,
        'Performance anxiety affecting sleep.');
    expect(find.byKey(const ValueKey<String>('session-summary-card')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('edit-session-summary')),
        findsOneWidget);
    expect(find.text('Session summary added'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('past psychologist session summaries are available and read-only',
      () async {
    final StubChatConversationRepository repository =
        StubChatConversationRepository();
    final ChatConversationModel conversation =
        await repository.fetchConversation(
      threadId: 'thread-psy-2',
      expertRole: ExpertRole.psychologist,
    );
    expect(
      conversation.messages.where((ChatMessageModel message) =>
          message.type == ChatMessageType.sessionSummary),
      hasLength(3),
    );
    expect(conversation.needsSessionSummary, isFalse);
    expect(
      conversation.messages
          .where((ChatMessageModel message) =>
              message.type == ChatMessageType.sessionSummary)
          .map((ChatMessageModel message) => message.summary?.sessionId),
      containsAll(<String>[
        'past-session-thread-psy-2-1',
        'past-session-thread-psy-2-2',
        'session-thread-psy-2',
      ]),
    );
  });

  testWidgets('astrologer opens Kundali from the chat banner',
      (WidgetTester tester) async {
    _configurePhone(tester);
    await tester.pumpWidget(
      _testApp(
        role: ExpertRole.astrologer,
        repository: _ConversationRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('View Kundali'), findsOneWidget);
    expect(find.text('Fill session summary'), findsNothing);
    expect(find.byKey(const ValueKey<String>('session-summary-card')),
        findsNothing);
    await tester.tap(find.text('View Kundali'));
    await tester.pumpAndSettle();

    expect(find.text('Kundali'), findsOneWidget);
    expect(find.text('Planet Short Forms'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('astrologer can send a typed message and attach a document',
      (WidgetTester tester) async {
    _configurePhone(tester);
    await tester.pumpWidget(
      _testApp(
        role: ExpertRole.astrologer,
        repository: _ConversationRepository(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey<String>('chat-message-field')),
      'Please practise this before our next session.',
    );
    await tester.tap(find.byKey(const ValueKey<String>('send-message-button')));
    await tester.pumpAndSettle();
    expect(find.text('Please practise this before our next session.'),
        findsOneWidget);

    await tester
        .tap(find.byKey(const ValueKey<String>('attach-document-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Session worksheet.pdf'));
    await tester.pumpAndSettle();
    expect(find.text('Session worksheet.pdf'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('call-end route hook opens the psychologist summary form',
      (WidgetTester tester) async {
    _configurePhone(tester);
    await tester.pumpWidget(
      _testApp(
        role: ExpertRole.psychologist,
        repository: _ConversationRepository(),
        promptSessionSummary: true,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Complete session summary'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('read-only-user-concern')),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _configurePhone(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

Widget _testApp({
  required ExpertRole role,
  required ChatConversationRepository repository,
  bool promptSessionSummary = false,
  String threadId = 'thread-1',
}) {
  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            ChatConversationPage(
          threadId: threadId,
          promptSessionSummary: promptSessionSummary,
        ),
      ),
      GoRoute(
        path: ExpertRoutes.kundali,
        builder: (BuildContext context, GoRouterState state) =>
            const KundaliPage(),
      ),
    ],
  );

  return ProviderScope(
    overrides: <Override>[
      expertProfileProvider.overrideWith(
        (Ref ref) async => ExpertProfile(
          id: 'expert-1',
          name: 'Expert',
          role: role,
          avatarUrl: '',
          isVerified: true,
        ),
      ),
      chatConversationRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

class _ConversationRepository implements ChatConversationRepository {
  String? savedPresentingConcern;

  @override
  Future<ChatConversationModel> fetchConversation({
    required String threadId,
    required ExpertRole expertRole,
  }) async =>
      ChatConversationModel(
        threadId: threadId,
        sessionId: 'session-1',
        clientName: 'Client One',
        consultationLabel: expertRole == ExpertRole.psychologist
            ? 'Video consultation ended'
            : 'Astrology consultation',
        expertRole: expertRole,
        isOnline: true,
        userConcern:
            expertRole == ExpertRole.psychologist ? 'Exam-related stress.' : '',
        messages: <ChatMessageModel>[
          ChatMessageModel(
            id: 'message-1',
            sender: ChatMessageSender.client,
            type: ChatMessageType.text,
            text: 'Hello',
            sentAt: DateTime(2026, 7, 16, 10),
          ),
          if (expertRole == ExpertRole.astrologer)
            ChatMessageModel(
              id: 'invalid-astrologer-summary',
              sender: ChatMessageSender.system,
              type: ChatMessageType.sessionSummary,
              sentAt: DateTime(2026, 7, 16, 10, 30),
              summary: SessionSummaryModel(
                id: 'invalid-summary',
                sessionId: 'session-1',
                userConcern: '',
                presentingConcern: 'This must never render for astrologers.',
                summaryNote: '',
                homework: '',
                exercises: const <RecommendedExercise>[],
                createdAt: DateTime(2026, 7, 16, 10, 30),
              ),
            ),
        ],
      );

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
    savedPresentingConcern = presentingConcern;
    final SessionSummaryModel summary = SessionSummaryModel(
      id: summaryId ?? 'summary-1',
      sessionId: sessionId,
      userConcern: userConcern,
      presentingConcern: presentingConcern,
      summaryNote: summaryNote,
      homework: homework,
      exercises: exercises,
      createdAt: DateTime(2026, 7, 16, 11),
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
  Future<ChatMessageModel> sendDocument({
    required String threadId,
    required String documentName,
  }) async =>
      ChatMessageModel(
        id: 'document-1',
        sender: ChatMessageSender.expert,
        type: ChatMessageType.document,
        sentAt: DateTime(2026, 7, 16, 11),
        documentName: documentName,
      );

  @override
  Future<ChatMessageModel> sendText({
    required String threadId,
    required String text,
  }) async =>
      ChatMessageModel(
        id: 'message-2',
        sender: ChatMessageSender.expert,
        type: ChatMessageType.text,
        sentAt: DateTime(2026, 7, 16, 11),
        text: text,
      );
}
