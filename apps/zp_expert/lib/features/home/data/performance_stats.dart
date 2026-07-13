import 'package:flutter/foundation.dart';

@immutable
class PerformanceStats {
  const PerformanceStats({
    required this.earningsToday,
    required this.averageRating,
    required this.responseTime,
    required this.missedSessions,
    required this.cancelledSessions,
  });

  final double earningsToday;
  final double averageRating;
  final Duration responseTime;
  final int missedSessions;
  final int cancelledSessions;
}