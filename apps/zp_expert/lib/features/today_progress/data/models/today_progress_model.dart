import 'package:flutter/foundation.dart';

@immutable
class TodayProgressData {
  const TodayProgressData({
    required this.overview,
    required this.sessionStatus,
    required this.consultation,
    required this.timeAvailability,
    required this.clientEngagement,
  });

  factory TodayProgressData.fromJson(Map<String, dynamic> json) {
    return TodayProgressData(
      overview:
          OverviewData.fromJson(json['overview'] as Map<String, dynamic>),
      sessionStatus: SessionStatusData.fromJson(
          json['sessionStatus'] as Map<String, dynamic>),
      consultation: ConsultationData.fromJson(
          json['consultation'] as Map<String, dynamic>),
      timeAvailability: TimeAvailabilityData.fromJson(
          json['timeAvailability'] as Map<String, dynamic>),
      clientEngagement: ClientEngagementData.fromJson(
          json['clientEngagement'] as Map<String, dynamic>),
    );
  }

  final OverviewData overview;
  final SessionStatusData sessionStatus;
  final ConsultationData consultation;
  final TimeAvailabilityData timeAvailability;
  final ClientEngagementData clientEngagement;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'overview': overview.toJson(),
        'sessionStatus': sessionStatus.toJson(),
        'consultation': consultation.toJson(),
        'timeAvailability': timeAvailability.toJson(),
        'clientEngagement': clientEngagement.toJson(),
      };
}

@immutable
class OverviewData {
  const OverviewData({
    required this.earningsToday,
    required this.sessionsCompleted,
    required this.consultationTime,
    required this.clientsServed,
  });

  factory OverviewData.fromJson(Map<String, dynamic> json) {
    return OverviewData(
      earningsToday: (json['earningsToday'] as num).toDouble(),
      sessionsCompleted: json['sessionsCompleted'] as int,
      consultationTime:
          Duration(minutes: json['consultationTimeMinutes'] as int),
      clientsServed: json['clientsServed'] as int,
    );
  }

  final double earningsToday;
  final int sessionsCompleted;
  final Duration consultationTime;
  final int clientsServed;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'earningsToday': earningsToday,
        'sessionsCompleted': sessionsCompleted,
        'consultationTimeMinutes': consultationTime.inMinutes,
        'clientsServed': clientsServed,
      };
}

@immutable
class SessionStatusData {
  const SessionStatusData({
    required this.completed,
    required this.upcoming,
    required this.active,
    required this.cancelledByClient,
    required this.cancelledByExpert,
    required this.missed,
  });

  factory SessionStatusData.fromJson(Map<String, dynamic> json) {
    return SessionStatusData(
      completed: json['completed'] as int,
      upcoming: json['upcoming'] as int,
      active: json['active'] as int,
      cancelledByClient: json['cancelledByClient'] as int,
      cancelledByExpert: json['cancelledByExpert'] as int,
      missed: json['missed'] as int,
    );
  }

  final int completed;
  final int upcoming;
  final int active;
  final int cancelledByClient;
  final int cancelledByExpert;
  final int missed;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'completed': completed,
        'upcoming': upcoming,
        'active': active,
        'cancelledByClient': cancelledByClient,
        'cancelledByExpert': cancelledByExpert,
        'missed': missed,
      };
}

@immutable
class ConsultationData {
  const ConsultationData({
    required this.chat,
    required this.voice,
    required this.video,
  });

  factory ConsultationData.fromJson(Map<String, dynamic> json) {
    return ConsultationData(
      chat: json['chat'] as int,
      voice: json['voice'] as int,
      video: json['video'] as int,
    );
  }

  final int chat;
  final int voice;
  final int video;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'chat': chat,
        'voice': voice,
        'video': video,
      };
}

@immutable
class TimeAvailabilityData {
  const TimeAvailabilityData({
    required this.onlineTime,
    required this.busyTime,
    required this.availableTime,
    required this.avgResponseTime,
  });

  factory TimeAvailabilityData.fromJson(Map<String, dynamic> json) {
    return TimeAvailabilityData(
      onlineTime: Duration(minutes: json['onlineTimeMinutes'] as int),
      busyTime: Duration(minutes: json['busyTimeMinutes'] as int),
      availableTime: Duration(minutes: json['availableTimeMinutes'] as int),
      avgResponseTime:
          Duration(seconds: json['avgResponseTimeSeconds'] as int),
    );
  }

  final Duration onlineTime;
  final Duration busyTime;
  final Duration availableTime;
  final Duration avgResponseTime;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'onlineTimeMinutes': onlineTime.inMinutes,
        'busyTimeMinutes': busyTime.inMinutes,
        'availableTimeMinutes': availableTime.inMinutes,
        'avgResponseTimeSeconds': avgResponseTime.inSeconds,
      };
}

@immutable
class ClientEngagementData {
  const ClientEngagementData({
    required this.newClients,
    required this.returningClients,
    required this.loyalClients,
    required this.avgRatingToday,
  });

  factory ClientEngagementData.fromJson(Map<String, dynamic> json) {
    return ClientEngagementData(
      newClients: json['newClients'] as int,
      returningClients: json['returningClients'] as int,
      loyalClients: json['loyalClients'] as int,
      avgRatingToday: (json['avgRatingToday'] as num).toDouble(),
    );
  }

  final int newClients;
  final int returningClients;
  final int loyalClients;
  final double avgRatingToday;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'newClients': newClients,
        'returningClients': returningClients,
        'loyalClients': loyalClients,
        'avgRatingToday': avgRatingToday,
      };
}
