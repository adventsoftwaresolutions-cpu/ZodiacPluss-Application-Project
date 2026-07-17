import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/chat/data/models/chat_thread_model.dart';
import 'package:zp_expert/features/chat/data/provider/chat_provider.dart';
import 'package:zp_expert/features/chat/data/repository/chat_repository.dart';
import 'package:zp_expert/shared/data/expert_profile.dart';
import 'package:zp_expert/shared/data/expert_profile_repository.dart';

void main() {
  test('chat inbox uses expert role and sorts newest message first', () async {
    final _RecordingChatRepository repository = _RecordingChatRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        expertProfileProvider.overrideWith(
          (Ref ref) async => const ExpertProfile(
            id: 'expert-astro',
            name: 'Aarav',
            role: ExpertRole.astrologer,
            avatarUrl: '',
            isVerified: true,
          ),
        ),
        chatRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final ChatInboxModel inbox = await container.read(chatInboxProvider.future);

    expect(repository.requestedRole, ExpertRole.astrologer);
    expect(
      inbox.threads.map((ChatThreadModel thread) => thread.id),
      <String>['latest', 'older'],
    );
  });

  test('stub repository keeps all psychologist clients without message text',
      () async {
    final StubChatRepository repository = StubChatRepository();

    final ChatInboxModel psychologist =
        await repository.fetchClientChats(ExpertRole.psychologist);
    final ChatInboxModel astrologer =
        await repository.fetchClientChats(ExpertRole.astrologer);

    expect(
      psychologist.threads.map((ChatThreadModel item) => item.clientName),
      containsAll(<String>['Ananya Singh', 'Aditya Raj', 'Anurag']),
    );
    expect(
      psychologist.threads
          .where((ChatThreadModel item) => item.id != 'thread-psy-2')
          .map((ChatThreadModel item) => item.lastMessage),
      everyElement('No session summary yet'),
    );
    expect(
      astrologer.threads.map((ChatThreadModel item) => item.consultationLabel),
      contains('Birth chart reading'),
    );
  });
}

class _RecordingChatRepository implements ChatRepository {
  ExpertRole? requestedRole;

  @override
  Future<ChatInboxModel> fetchClientChats(ExpertRole expertRole) async {
    requestedRole = expertRole;
    return ChatInboxModel(
      expertRole: expertRole,
      threads: <ChatThreadModel>[
        ChatThreadModel(
          id: 'older',
          clientId: 'client-1',
          clientName: 'Older Client',
          consultationLabel: 'Career astrology',
          lastMessage: 'Older message',
          lastMessageAt: DateTime(2026, 1),
          unreadCount: 0,
          lastMessageSentByExpert: false,
          isOnline: false,
        ),
        ChatThreadModel(
          id: 'latest',
          clientId: 'client-2',
          clientName: 'Latest Client',
          consultationLabel: 'Birth chart reading',
          lastMessage: 'Latest message',
          lastMessageAt: DateTime(2026, 2),
          unreadCount: 1,
          lastMessageSentByExpert: false,
          isOnline: true,
        ),
      ],
    );
  }
}
