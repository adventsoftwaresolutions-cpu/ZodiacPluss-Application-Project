abstract final class ExpertRoutes {
  static const String auth = '/auth';
  static const String verification = '/verification';
  static const String verificationPending = '/verification-pending';
  static const String verificationComplete = '/verification-complete';
  static const String verificationFailed = '/verification-failed';
  static const String maxAttempts = '/max-attempt';
  static const String home = '/home';
  static const String wallet = '/wallet';
  static const String profile = '/profile';
  static const String sessionHistory = '/session';
  static const String sessionInfo = '$sessionHistory/:sessionId';
  static const String clients = '/clients';
  static const String managePricing = '/manage-pricing';
  static const String reviews = '/reviews';
  static const String chats = '/chats';
  static const String chatConversation = '$chats/:threadId';
  static const String callRoom = '/call-room/:roomId';
  static const String clientHistory = '$clients/:clientId';
  static const String raiseTicket = '/raise-ticket';
  static const String ticketStatus = '/ticket-status';
  static const String contact = '/contact';
  static const String faq = '/faq';

  static String sessionInfoFor(String sessionId) =>
      '$sessionHistory/$sessionId';

  static String clientHistoryFor(String clientId) => '$clients/$clientId';

  static String chatConversationFor(
    String threadId, {
    bool promptSessionSummary = false,
  }) {
    final String location = '$chats/$threadId';
    return promptSessionSummary ? '$location?promptSummary=true' : location;
  }

  static String callRoomFor(String roomId) => '/call-room/$roomId';
}
