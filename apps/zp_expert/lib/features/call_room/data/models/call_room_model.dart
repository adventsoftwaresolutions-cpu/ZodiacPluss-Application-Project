import 'package:flutter/foundation.dart';

import '../../../../shared/data/expert_profile.dart';

enum CallRoomType { audio, video }

extension CallRoomTypeLabel on CallRoomType {
  String get label => switch (this) {
        CallRoomType.audio => 'Audio call',
        CallRoomType.video => 'Video call',
      };
}

@immutable
class CallRoomModel {
  const CallRoomModel({
    required this.id,
    required this.threadId,
    required this.clientId,
    required this.clientName,
    required this.type,
    required this.paidMinutes,
    required this.clientPresent,
    required this.readyAt,
    required this.queuePosition,
    this.state = 'scheduled',
    this.expectedEndAt,
    this.requestExpiresAt,
  });

  factory CallRoomModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : const <String, dynamic>{};
    final int fundedAmountPaise = _int(json['fundedAmountPaise']);
    final int ratePerMinutePaise = _int(json['ratePerMinutePaise']);
    final int paidMinutes = ratePerMinutePaise <= 0
        ? 0
        : (fundedAmountPaise / ratePerMinutePaise).ceil();
    final String clientId =
        user['id']?.toString() ?? json['clientId']?.toString() ?? '';
    final String mode =
        json['mode']?.toString() ?? json['type']?.toString() ?? 'audio';
    return CallRoomModel(
      id: json['id'].toString(),
      threadId: json['threadId']?.toString() ?? clientId,
      clientId: clientId,
      clientName: user['displayName']?.toString() ??
          json['clientName']?.toString() ??
          'Client',
      type: mode == 'video' ? CallRoomType.video : CallRoomType.audio,
      paidMinutes: paidMinutes > 0 ? paidMinutes : _int(json['paidMinutes']),
      clientPresent: json['clientPresent'] as bool? ?? false,
      readyAt:
          _date(json['requestedAt'] ?? json['createdAt'] ?? json['readyAt']) ??
              DateTime.now(),
      queuePosition: _int(json['queuePosition'], fallback: 1),
      state: json['state']?.toString() ?? 'scheduled',
      expectedEndAt: _date(json['expectedEndAt']),
      requestExpiresAt: _date(json['requestExpiresAt']),
    );
  }

  final String id;
  final String threadId;
  final String clientId;
  final String clientName;
  final CallRoomType type;
  final int paidMinutes;
  final bool clientPresent;
  final DateTime readyAt;
  final int queuePosition;
  final String state;
  final DateTime? expectedEndAt;
  final DateTime? requestExpiresAt;

  bool get isLive => state == 'live';

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'threadId': threadId,
        'clientId': clientId,
        'clientName': clientName,
        'type': type.name,
        'paidMinutes': paidMinutes,
        'clientPresent': clientPresent,
        'readyAt': readyAt.toIso8601String(),
        'queuePosition': queuePosition,
        'state': state,
        'expectedEndAt': expectedEndAt?.toIso8601String(),
        'requestExpiresAt': requestExpiresAt?.toIso8601String(),
      };
}

@immutable
class AgoraCredentials {
  const AgoraCredentials({
    required this.appId,
    required this.channelName,
    required this.uid,
    required this.token,
    required this.selfDisplayName,
    required this.remoteDisplayName,
  });

  factory AgoraCredentials.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> payload = json['credentials'] is Map
        ? Map<String, dynamic>.from(json['credentials'] as Map)
        : json;
    final Map<String, dynamic> self = payload['self'] is Map
        ? Map<String, dynamic>.from(payload['self'] as Map)
        : const <String, dynamic>{};
    final Map<String, dynamic> remote = payload['remote'] is Map
        ? Map<String, dynamic>.from(payload['remote'] as Map)
        : const <String, dynamic>{};
    return AgoraCredentials(
      appId: _requiredString(payload, 'appId'),
      channelName: _requiredString(payload, 'channelName'),
      uid: _int(payload['uid']),
      token: _requiredString(payload, 'token'),
      selfDisplayName: self['displayName']?.toString() ?? 'You',
      remoteDisplayName: remote['displayName']?.toString() ?? 'Client',
    );
  }

  final String appId;
  final String channelName;
  final int uid;
  final String token;
  final String selfDisplayName;
  final String remoteDisplayName;
}

enum ConsultationEventType { requested, live, ended, other }

@immutable
class ConsultationEvent {
  const ConsultationEvent({required this.type, required this.room});

  final ConsultationEventType type;
  final CallRoomModel room;
}

enum CallSessionPhase { waitingForClient, connected, ended }

@immutable
class CallSessionState {
  const CallSessionState({
    required this.room,
    required this.expertRole,
    required this.phase,
    this.elapsedSeconds = 0,
    this.isMuted = false,
    this.isSpeakerOn = true,
    this.isVideoOn = true,
    this.endedAutomatically = false,
  });

  final CallRoomModel room;
  final ExpertRole expertRole;
  final CallSessionPhase phase;
  final int elapsedSeconds;
  final bool isMuted;
  final bool isSpeakerOn;
  final bool isVideoOn;
  final bool endedAutomatically;

  CallSessionState copyWith({
    CallRoomModel? room,
    CallSessionPhase? phase,
    int? elapsedSeconds,
    bool? isMuted,
    bool? isSpeakerOn,
    bool? isVideoOn,
    bool? endedAutomatically,
  }) =>
      CallSessionState(
        room: room ?? this.room,
        expertRole: expertRole,
        phase: phase ?? this.phase,
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
        isMuted: isMuted ?? this.isMuted,
        isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
        isVideoOn: isVideoOn ?? this.isVideoOn,
        endedAutomatically: endedAutomatically ?? this.endedAutomatically,
      );
}

int _int(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

DateTime? _date(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

String _requiredString(Map<String, dynamic> json, String key) {
  final String value = json[key]?.toString() ?? '';
  if (value.isEmpty) {
    throw FormatException('Agora credentials are missing $key.');
  }
  return value;
}
