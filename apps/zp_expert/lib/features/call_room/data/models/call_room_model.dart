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
  });

  final String id;
  final String threadId;
  final String clientId;
  final String clientName;
  final CallRoomType type;
  final int paidMinutes;
  final bool clientPresent;
  final DateTime readyAt;
  final int queuePosition;

  factory CallRoomModel.fromJson(Map<String, dynamic> json) => CallRoomModel(
        id: json['id'] as String,
        threadId: json['threadId'] as String,
        clientId: json['clientId'] as String,
        clientName: json['clientName'] as String,
        type: CallRoomType.values.byName(json['type'] as String),
        paidMinutes: json['paidMinutes'] as int,
        clientPresent: json['clientPresent'] as bool? ?? false,
        readyAt: DateTime.parse(json['readyAt'] as String),
        queuePosition: json['queuePosition'] as int? ?? 1,
      );

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
      };
}

enum CallSessionPhase { waitingForClient, connected, ended }

@immutable
class CallSessionState {
  const CallSessionState({
    required this.room,
    required this.expertRole,
    required this.phase,
    this.waitingSeconds = 60,
    this.elapsedSeconds = 0,
    this.isMuted = false,
    this.isSpeakerOn = true,
    this.isVideoOn = true,
    this.endedAutomatically = false,
  });

  final CallRoomModel room;
  final ExpertRole expertRole;
  final CallSessionPhase phase;
  final int waitingSeconds;
  final int elapsedSeconds;
  final bool isMuted;
  final bool isSpeakerOn;
  final bool isVideoOn;
  final bool endedAutomatically;

  CallSessionState copyWith({
    CallSessionPhase? phase,
    int? waitingSeconds,
    int? elapsedSeconds,
    bool? isMuted,
    bool? isSpeakerOn,
    bool? isVideoOn,
    bool? endedAutomatically,
  }) =>
      CallSessionState(
        room: room,
        expertRole: expertRole,
        phase: phase ?? this.phase,
        waitingSeconds: waitingSeconds ?? this.waitingSeconds,
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
        isMuted: isMuted ?? this.isMuted,
        isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
        isVideoOn: isVideoOn ?? this.isVideoOn,
        endedAutomatically: endedAutomatically ?? this.endedAutomatically,
      );
}
