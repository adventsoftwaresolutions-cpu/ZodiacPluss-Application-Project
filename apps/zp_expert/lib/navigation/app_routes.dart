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
  static const String clientHistory = '$clients/:clientId';
  static const String raiseTicket = '/raise-ticket';
  static const String ticketStatus = '/ticket-status';
  static const String contact = '/contact';
  static const String faq = '/faq';

  static String sessionInfoFor(String sessionId) =>
      '$sessionHistory/$sessionId';

  static String clientHistoryFor(String clientId) => '$clients/$clientId';
}
