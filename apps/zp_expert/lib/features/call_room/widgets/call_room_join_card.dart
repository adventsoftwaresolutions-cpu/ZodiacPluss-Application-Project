import 'package:flutter/material.dart';

import '../../../themes/app_radius.dart';
import '../../../shared/data/expert_profile.dart';
import '../data/models/call_room_model.dart';
import 'call_invitation_effects.dart';

class CallRoomJoinCard extends StatelessWidget {
  const CallRoomJoinCard({
    required this.room,
    required this.expertRole,
    required this.onJoin,
    this.compact = false,
    super.key,
  });

  final CallRoomModel room;
  final ExpertRole expertRole;
  final VoidCallback onJoin;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return RevolvingCallBorder(
      borderRadius: AppRadius.lg,
      child: Container(
        key: ValueKey<String>('join-room-card-${room.id}'),
        padding: EdgeInsets.all(compact ? 10 : 13),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.primary.withValues(alpha: .2)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.shadow.withValues(alpha: .12),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(children: <Widget>[
          CircleAvatar(
            backgroundColor: colors.primary.withValues(alpha: .12),
            foregroundColor: colors.primary,
            child: Icon(
              room.type == CallRoomType.video
                  ? Icons.video_call_rounded
                  : Icons.call_rounded,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  room.isLive
                      ? 'Consultation in progress'
                      : expertRole == ExpertRole.psychologist
                          ? (compact
                              ? 'Paid room ready'
                              : '${room.type.label} room ready')
                          : '${room.type.label} room ready',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  expertRole == ExpertRole.psychologist
                      ? '${room.clientName} · ${room.paidMinutes} min'
                      : room.clientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AttentionJoinButton(
            key: ValueKey<String>('join-room-button-${room.id}'),
            onPressed: onJoin,
            label: room.isLive ? 'Rejoin' : 'Join',
          ),
        ]),
      ),
    );
  }
}
