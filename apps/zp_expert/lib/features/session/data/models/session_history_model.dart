enum SessionType { voice, chat, video }

class SessionHistoryModel {
  const SessionHistoryModel({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.startedAt,
    required this.earnings,
  });

  final String id;
  final SessionType type;
  final int durationMinutes;
  final DateTime startedAt;
  final int earnings;

  String get title {
    switch (type) {
      case SessionType.voice:
        return 'Voice Call';
      case SessionType.chat:
        return 'Chat';
      case SessionType.video:
        return 'Video Call';
    }
  }

  factory SessionHistoryModel.fromJson(Map<String, dynamic> json) {
    return SessionHistoryModel(
      id: json['id'] as String,
      type: SessionType.values.byName(json['type'] as String),
      durationMinutes: json['durationMinutes'] as int,
      startedAt: DateTime.parse(json['startedAt'] as String),
      earnings: json['earnings'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type.name,
      'durationMinutes': durationMinutes,
      'startedAt': startedAt.toIso8601String(),
      'earnings': earnings,
    };
  }
}

class SessionPerson {
  const SessionPerson({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarAsset,
  });

  final String id;
  final String name;
  final String role;
  final String avatarAsset;

  factory SessionPerson.fromJson(Map<String, dynamic> json) {
    return SessionPerson(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      avatarAsset: json['avatarAsset'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'role': role,
        'avatarAsset': avatarAsset,
      };
}

class SessionDetailModel {
  const SessionDetailModel({
    required this.session,
    required this.client,
    required this.expert,
    required this.status,
    required this.grossAmount,
    required this.tax,
    required this.platformFee,
    required this.bonus,
    required this.userConcern,
    required this.presentingConcern,
    required this.homework,
    required this.exercise,
    required this.attachmentName,
    required this.attachmentSize,
    required this.recordingDuration,
  });

  final SessionHistoryModel session;
  final SessionPerson client;
  final SessionPerson expert;
  final String status;
  final double grossAmount;
  final double tax;
  final double platformFee;
  final double bonus;
  final String userConcern;
  final String presentingConcern;
  final String homework;
  final String exercise;
  final String attachmentName;
  final String attachmentSize;
  final String recordingDuration;

  double get netEarnings => grossAmount - tax - platformFee + bonus;

  factory SessionDetailModel.fromJson(Map<String, dynamic> json) {
    return SessionDetailModel(
      session: SessionHistoryModel.fromJson(
        json['session'] as Map<String, dynamic>,
      ),
      client: SessionPerson.fromJson(json['client'] as Map<String, dynamic>),
      expert: SessionPerson.fromJson(json['expert'] as Map<String, dynamic>),
      status: json['status'] as String,
      grossAmount: (json['grossAmount'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      platformFee: (json['platformFee'] as num).toDouble(),
      bonus: (json['bonus'] as num).toDouble(),
      userConcern: json['userConcern'] as String,
      presentingConcern: json['presentingConcern'] as String,
      homework: json['homework'] as String,
      exercise: json['exercise'] as String,
      attachmentName: json['attachmentName'] as String,
      attachmentSize: json['attachmentSize'] as String,
      recordingDuration: json['recordingDuration'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'session': session.toJson(),
        'client': client.toJson(),
        'expert': expert.toJson(),
        'status': status,
        'grossAmount': grossAmount,
        'tax': tax,
        'platformFee': platformFee,
        'bonus': bonus,
        'userConcern': userConcern,
        'presentingConcern': presentingConcern,
        'homework': homework,
        'exercise': exercise,
        'attachmentName': attachmentName,
        'attachmentSize': attachmentSize,
        'recordingDuration': recordingDuration,
      };
}
