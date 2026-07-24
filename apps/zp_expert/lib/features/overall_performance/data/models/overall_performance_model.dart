import 'package:flutter/foundation.dart';

@immutable
class PerformanceMetrics {
  const PerformanceMetrics({
    required this.totalEarning,
    required this.totalSessionsCompleted,
    required this.totalConsultationTime,
    required this.totalClientsServed,
    required this.cancelledByClient,
    required this.cancelledByExpert,
    required this.missed,
    required this.totalOnlineTime,
    required this.totalBusyTime,
    required this.avgResponseTime,
  });

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      totalEarning: (json['totalEarning'] as num).toDouble(),
      totalSessionsCompleted: json['totalSessionsCompleted'] as int,
      totalConsultationTime:
          Duration(minutes: json['totalConsultationTimeMinutes'] as int),
      totalClientsServed: json['totalClientsServed'] as int,
      cancelledByClient: json['cancelledByClient'] as int,
      cancelledByExpert: json['cancelledByExpert'] as int,
      missed: json['missed'] as int,
      totalOnlineTime:
          Duration(minutes: json['totalOnlineTimeMinutes'] as int),
      totalBusyTime: Duration(minutes: json['totalBusyTimeMinutes'] as int),
      avgResponseTime:
          Duration(seconds: json['avgResponseTimeSeconds'] as int),
    );
  }

  final double totalEarning;
  final int totalSessionsCompleted;
  final Duration totalConsultationTime;
  final int totalClientsServed;
  final int cancelledByClient;
  final int cancelledByExpert;
  final int missed;
  final Duration totalOnlineTime;
  final Duration totalBusyTime;
  final Duration avgResponseTime;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'totalEarning': totalEarning,
        'totalSessionsCompleted': totalSessionsCompleted,
        'totalConsultationTimeMinutes': totalConsultationTime.inMinutes,
        'totalClientsServed': totalClientsServed,
        'cancelledByClient': cancelledByClient,
        'cancelledByExpert': cancelledByExpert,
        'missed': missed,
        'totalOnlineTimeMinutes': totalOnlineTime.inMinutes,
        'totalBusyTimeMinutes': totalBusyTime.inMinutes,
        'avgResponseTimeSeconds': avgResponseTime.inSeconds,
      };
}
