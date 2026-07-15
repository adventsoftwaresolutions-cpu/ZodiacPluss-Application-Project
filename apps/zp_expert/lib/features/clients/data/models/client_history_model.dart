import 'client_model.dart';

enum ClientSessionType { voice, chat, video }

class ClientSessionModel {
  const ClientSessionModel({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.scheduledAt,
    required this.earnings,
    required this.isUpcoming,
  });

  final String id;
  final ClientSessionType type;
  final int durationMinutes;
  final DateTime scheduledAt;
  final int earnings;
  final bool isUpcoming;

  String get title {
    switch (type) {
      case ClientSessionType.voice:
        return 'Voice Call';
      case ClientSessionType.chat:
        return 'Chat';
      case ClientSessionType.video:
        return 'Video Call';
    }
  }

  factory ClientSessionModel.fromJson(Map<String, dynamic> json) {
    return ClientSessionModel(
      id: json['id'] as String,
      type: ClientSessionType.values.byName(json['type'] as String),
      durationMinutes: json['durationMinutes'] as int,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      earnings: json['earnings'] as int,
      isUpcoming: json['isUpcoming'] as bool,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type.name,
        'durationMinutes': durationMinutes,
        'scheduledAt': scheduledAt.toIso8601String(),
        'earnings': earnings,
        'isUpcoming': isUpcoming,
      };
}

class ClientHistoryModel {
  const ClientHistoryModel({
    required this.client,
    required this.age,
    required this.gender,
    required this.location,
    required this.isRisky,
    required this.totalDurationLabel,
    required this.totalEarned,
    required this.firstSessionDate,
    required this.pastSessions,
    required this.upcomingSessions,
  });

  final ClientModel client;
  final int age;
  final String gender;
  final String location;
  final bool isRisky;
  final String totalDurationLabel;
  final int totalEarned;
  final DateTime firstSessionDate;
  final List<ClientSessionModel> pastSessions;
  final List<ClientSessionModel> upcomingSessions;

  factory ClientHistoryModel.fromJson(Map<String, dynamic> json) {
    return ClientHistoryModel(
      client: ClientModel.fromJson(json['client'] as Map<String, dynamic>),
      age: json['age'] as int,
      gender: json['gender'] as String,
      location: json['location'] as String,
      isRisky: json['isRisky'] as bool,
      totalDurationLabel: json['totalDurationLabel'] as String,
      totalEarned: json['totalEarned'] as int,
      firstSessionDate: DateTime.parse(json['firstSessionDate'] as String),
      pastSessions: (json['pastSessions'] as List<dynamic>)
          .map((item) =>
              ClientSessionModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      upcomingSessions: (json['upcomingSessions'] as List<dynamic>)
          .map((item) =>
              ClientSessionModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'client': client.toJson(),
        'age': age,
        'gender': gender,
        'location': location,
        'isRisky': isRisky,
        'totalDurationLabel': totalDurationLabel,
        'totalEarned': totalEarned,
        'firstSessionDate': firstSessionDate.toIso8601String(),
        'pastSessions': pastSessions.map((item) => item.toJson()).toList(),
        'upcomingSessions':
            upcomingSessions.map((item) => item.toJson()).toList(),
      };
}
