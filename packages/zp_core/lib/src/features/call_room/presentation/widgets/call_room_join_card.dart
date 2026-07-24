import 'package:flutter/material.dart';

import '../../data/models/call_room_model.dart';
import 'call_invitation_effects.dart';

/// A card that displays an incoming or active consultation room with a join
/// button, wrapped in a revolving glow border for attention.
///
/// Instead of accepting `ExpertRole` (which is app-specific), this widget
/// accepts plain [title] and [subtitle] strings so the calling app can compose
/// the appropriate labels.
class CallRoomJoinCard extends StatelessWidget {
  const CallRoomJoinCard({
    required this.room,
    required this.title,
    required this.subtitle,
    required this.onJoin,
    this.compact = false,
    this.borderRadius = 16,
    super.key,
  });

  final CallRoomModel room;

  /// Primary line of text (e.g. "Video call room ready").
  final String title;

  /// Secondary line of text (e.g. "Client Name · 5 min").
  final String subtitle;

  final VoidCallback onJoin;
  final bool compact;

  /// Border radius of the card. Defaults to 16 (AppRadius.lg).
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return RevolvingCallBorder(
      borderRadius: borderRadius,
      child: Container(
        key: ValueKey<String>('join-room-card-${room.id}'),
        padding: EdgeInsets.all(compact ? 10 : 13),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(borderRadius),
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
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
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
