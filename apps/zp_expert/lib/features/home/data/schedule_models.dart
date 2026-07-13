import 'package:flutter/foundation.dart';

enum SessionType { video, voice, chat }

extension SessionTypeLabel on SessionType {
  String get label {
    switch (this) {
      case SessionType.video:
        return 'Video Consultation';
      case SessionType.voice:
        return 'Voice Consultation';
      case SessionType.chat:
        return 'Chat Consultation';
    }
  }
}

enum AppointmentStatus { upcoming, completed, cancelled }

@immutable
class AppointmentEntry {
  const AppointmentEntry({
    required this.id,
    required this.scheduledAt,
    required this.duration,
    required this.clientName,
    required this.clientAvatarUrl,
    required this.sessionType,
    required this.status,
  });

  final String id;
  final DateTime scheduledAt;
  final Duration duration;
  final String clientName;
  final String clientAvatarUrl;
  final SessionType sessionType;
  final AppointmentStatus status;

  AppointmentEntry copyWith({AppointmentStatus? status}) {
    return AppointmentEntry(
      id: id,
      scheduledAt: scheduledAt,
      duration: duration,
      clientName: clientName,
      clientAvatarUrl: clientAvatarUrl,
      sessionType: sessionType,
      status: status ?? this.status,
    );
  }
}

enum ClientTier { normal, loyal }

extension ClientTierLabel on ClientTier {
  String get label =>
      this == ClientTier.loyal ? 'Loyal User' : 'Normal User';
}

@immutable
class QueueEntry {
  const QueueEntry({
    required this.id,
    required this.position,
    required this.clientName,
    required this.clientAvatarUrl,
    required this.sessionType,
    required this.tier,
  });

  final String id;
  final int position;
  final String clientName;
  final String clientAvatarUrl;
  final SessionType sessionType;
  final ClientTier tier;
}

/// Unifies the two shapes at exactly one point — the boundary the
/// widget dispatcher reads. Nothing else in the app should need to
/// know both variants exist.
sealed class ScheduleViewData {
  const ScheduleViewData();
}

class AppointmentScheduleData extends ScheduleViewData {
  const AppointmentScheduleData(this.appointments);
  final List<AppointmentEntry> appointments;
}

class QueueScheduleData extends ScheduleViewData {
  const QueueScheduleData(this.queue);
  final List<QueueEntry> queue;
}