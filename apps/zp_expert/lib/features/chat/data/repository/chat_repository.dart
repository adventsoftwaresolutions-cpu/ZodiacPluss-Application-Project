import '../../../../shared/data/expert_profile.dart';
import '../models/chat_thread_model.dart';

abstract class ChatRepository {
  Future<ChatInboxModel> fetchClientChats(ExpertRole expertRole);
}

class StubChatRepository implements ChatRepository {
  @override
  Future<ChatInboxModel> fetchClientChats(ExpertRole expertRole) async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
    return ChatInboxModel(
      expertRole: expertRole,
      threads: expertRole == ExpertRole.psychologist
          ? _psychologistThreads()
          : _astrologerThreads(),
    );
  }

  /// Psychologist messaging is unavailable for the MVP. Threads remain
  /// available so each client's current or completed session summary can be
  /// opened, but the inbox does not expose message text.
  List<ChatThreadModel> _psychologistThreads() {
    final DateTime now = DateTime.now();
    return <ChatThreadModel>[
      ChatThreadModel(
        id: 'thread-psy-3',
        clientId: 'client-103',
        clientName: 'Meera Iyer',
        consultationLabel: 'Stress management',
        lastMessage: 'No session summary yet',
        lastMessageAt: now.subtract(const Duration(days: 2, hours: 3)),
        unreadCount: 0,
        lastMessageSentByExpert: false,
        isOnline: false,
      ),
      ChatThreadModel(
        id: 'thread-psy-1',
        clientId: 'client-101',
        clientName: 'Ananya Singh',
        consultationLabel: 'Anxiety support',
        lastMessage: 'No session summary yet',
        lastMessageAt: now.subtract(const Duration(minutes: 18)),
        unreadCount: 0,
        lastMessageSentByExpert: false,
        isOnline: true,
      ),
      ChatThreadModel(
        id: 'thread-psy-4',
        clientId: 'client-104',
        clientName: 'Rohan Mehta',
        consultationLabel: 'Relationship counselling',
        lastMessage: 'No session summary yet',
        lastMessageAt: now.subtract(const Duration(days: 5)),
        unreadCount: 0,
        lastMessageSentByExpert: false,
        isOnline: false,
      ),
      ChatThreadModel(
        id: 'thread-psy-2',
        clientId: 'client-102',
        clientName: 'Kabir Shah',
        consultationLabel: 'Wellness check-in',
        lastMessage: 'Session summary added',
        lastMessageAt: now.subtract(const Duration(hours: 5)),
        unreadCount: 0,
        lastMessageSentByExpert: true,
        isOnline: false,
      ),
      ChatThreadModel(
        id: 'thread-psy-5',
        clientId: 'client-105',
        clientName: 'Aditya Raj',
        consultationLabel: 'Stress related issues',
        lastMessage: 'No session summary yet',
        lastMessageAt: now.subtract(const Duration(hours: 5)),
        unreadCount: 0,
        lastMessageSentByExpert: false,
        isOnline: false,
      ),
      ChatThreadModel(
        id: 'thread-psy-6',
        clientId: 'client-106',
        clientName: 'Anurag',
        consultationLabel: 'Wellness check-in',
        lastMessage: 'No session summary yet',
        lastMessageAt: now.subtract(const Duration(hours: 5)),
        unreadCount: 0,
        lastMessageSentByExpert: false,
        isOnline: true,
      ),
    ];
  }

  List<ChatThreadModel> _astrologerThreads() {
    final DateTime now = DateTime.now();
    return <ChatThreadModel>[
      ChatThreadModel(
        id: 'thread-astro-2',
        clientId: 'client-202',
        clientName: 'Ishita Kapoor',
        consultationLabel: 'Marriage compatibility',
        lastMessage: 'I have shared the birth details you requested.',
        lastMessageAt: now.subtract(const Duration(hours: 3)),
        unreadCount: 1,
        lastMessageSentByExpert: false,
        isOnline: true,
      ),
      ChatThreadModel(
        id: 'thread-astro-1',
        clientId: 'client-201',
        clientName: 'Aarav Malhotra',
        consultationLabel: 'Birth chart reading',
        lastMessage:
            'Thank you for explaining the upcoming transit so clearly.',
        lastMessageAt: now.subtract(const Duration(minutes: 12)),
        unreadCount: 3,
        lastMessageSentByExpert: false,
        isOnline: true,
      ),
      ChatThreadModel(
        id: 'thread-astro-4',
        clientId: 'client-204',
        clientName: 'Neha Joshi',
        consultationLabel: 'Vastu consultation',
        lastMessage: 'Keep the entrance well-lit and clutter-free.',
        lastMessageAt: now.subtract(const Duration(days: 4)),
        unreadCount: 0,
        lastMessageSentByExpert: true,
        isOnline: false,
      ),
      ChatThreadModel(
        id: 'thread-astro-3',
        clientId: 'client-203',
        clientName: 'Dev Patel',
        consultationLabel: 'Career astrology',
        lastMessage: 'When would be a good time to begin the new role?',
        lastMessageAt: now.subtract(const Duration(days: 1, hours: 2)),
        unreadCount: 0,
        lastMessageSentByExpert: false,
        isOnline: false,
      ),
    ];
  }
}
