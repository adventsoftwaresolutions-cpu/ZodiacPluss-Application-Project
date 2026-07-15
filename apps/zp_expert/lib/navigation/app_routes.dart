abstract final class ExpertRoutes {
  static const String sessionHistory = '/session';
  static const String sessionInfo = '$sessionHistory/:sessionId';

  static String sessionInfoFor(String sessionId) =>
      '$sessionHistory/$sessionId';
}
