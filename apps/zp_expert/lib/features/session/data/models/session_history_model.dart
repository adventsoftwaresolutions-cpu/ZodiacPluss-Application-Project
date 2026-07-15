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
