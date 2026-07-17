import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/chat/chat.dart';
import 'package:zp_expert/features/chat/data/models/chat_thread_model.dart';
import 'package:zp_expert/features/chat/data/provider/chat_provider.dart';
import 'package:zp_expert/features/chat/data/repository/chat_repository.dart';
import 'package:zp_expert/features/chat/widgets/chat_thread_card.dart';
import 'package:zp_expert/features/chat/widgets/chat_inbox_content.dart';
import 'package:zp_expert/features/session/widgets/session_history_header.dart';
import 'package:zp_expert/shared/data/expert_profile.dart';
import 'package:zp_expert/shared/data/expert_profile_repository.dart';
import 'package:zp_expert/shared/widgets/header_action_buttons.dart';

void main() {
  testWidgets('chat page shows role-aware inbox and unread filtering',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          expertProfileProvider.overrideWith(
            (Ref ref) async => const ExpertProfile(
              id: 'expert-1',
              name: 'Shreya',
              role: ExpertRole.psychologist,
              avatarUrl: '',
              isVerified: true,
            ),
          ),
          chatRepositoryProvider.overrideWithValue(_WidgetChatRepository()),
        ],
        child: const MaterialApp(home: ChatInboxPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Client Chats'), findsOneWidget);
    expect(find.byTooltip('Notifications'), findsNothing);
    expect(find.byTooltip('Client chats'), findsNothing);
    expect(find.text('Private consultation follow-ups'), findsOneWidget);
    expect(find.text('Newest Client'), findsOneWidget);
    expect(find.text('Older Client'), findsOneWidget);
    expect(find.textContaining('Newest message'), findsOneWidget);
    expect(find.textContaining('Older message'), findsOneWidget);
    expect(find.text('Anxiety support'), findsOneWidget);
    expect(find.text('Stress management'), findsOneWidget);
    expect(find.text('Unread 1'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Unread 1'));
    await tester.pumpAndSettle();
    expect(find.text('Newest Client'), findsOneWidget);
    expect(find.text('Older Client'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chat card fits narrow screens with enlarged text',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 600),
              textScaler: TextScaler.linear(1.3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ChatThreadCard(
                expertRole: ExpertRole.astrologer,
                thread: ChatThreadModel(
                  id: 'thread-1',
                  clientId: 'client-1',
                  clientName: 'A Client With A Long Name',
                  consultationLabel: 'Marriage compatibility consultation',
                  lastMessage:
                      'I have shared all the birth details you requested.',
                  lastMessageAt: DateTime.now(),
                  unreadCount: 12,
                  lastMessageSentByExpert: false,
                  isOnline: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('I have shared all the birth details you requested.'),
      findsOneWidget,
    );
    expect(find.text('Marriage compatibility consultation'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('top-bar chat button invokes its navigation callback',
      (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeaderActionButtons(
            onNotificationTap: () {},
            onChatTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Client chats'));
    expect(tapped, isTrue);
  });

  testWidgets('chat header fits the page content width',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 350,
            child: SessionHistoryHeader(
              title: 'Client Chats',
              subtitle: 'Continue conversations with past clients',
              onBackTap: () {},
              onNotificationTap: () {},
              onChatTap: () {},
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('chat inbox content fits the page content width',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          expertProfileProvider.overrideWith(
            (Ref ref) async => const ExpertProfile(
              id: 'expert-1',
              name: 'Shreya',
              role: ExpertRole.psychologist,
              avatarUrl: '',
              isVerified: true,
            ),
          ),
          chatRepositoryProvider.overrideWithValue(_WidgetChatRepository()),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 350,
              height: 700,
              child: ChatInboxContent(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

class _WidgetChatRepository implements ChatRepository {
  @override
  Future<ChatInboxModel> fetchClientChats(ExpertRole expertRole) async =>
      ChatInboxModel(
        expertRole: expertRole,
        threads: <ChatThreadModel>[
          ChatThreadModel(
            id: 'older',
            clientId: 'client-1',
            clientName: 'Older Client',
            consultationLabel: 'Stress management',
            lastMessage: 'Older message',
            lastMessageAt: DateTime(2026, 1),
            unreadCount: 0,
            lastMessageSentByExpert: true,
            isOnline: false,
          ),
          ChatThreadModel(
            id: 'latest',
            clientId: 'client-2',
            clientName: 'Newest Client',
            consultationLabel: 'Anxiety support',
            lastMessage: 'Newest message',
            lastMessageAt: DateTime(2026, 2),
            unreadCount: 2,
            lastMessageSentByExpert: false,
            isOnline: true,
          ),
        ],
      );
}
