abstract final class ExpertRoutes {
  static const String sessionHistory = '/session';
  static const String sessionInfo = '$sessionHistory/:sessionId';
  static const String clients = '/clients';
  static const String clientHistory = '$clients/:clientId';

  static String sessionInfoFor(String sessionId) =>
      '$sessionHistory/$sessionId';

  static String clientHistoryFor(String clientId) => '$clients/$clientId';
}
