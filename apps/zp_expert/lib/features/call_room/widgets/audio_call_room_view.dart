import 'package:flutter/material.dart';

import '../data/models/call_room_model.dart';
import 'call_controls.dart';
import 'call_participant_avatar.dart';
import 'call_status_text.dart';

class AudioCallRoomView extends StatelessWidget {
  const AudioCallRoomView({
    required this.session,
    required this.onToggleMute,
    required this.onToggleSpeaker,
    required this.onMessage,
    required this.onEndCall,
    required this.onLeave,
    super.key,
  });

  final CallSessionState session;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleSpeaker;
  final VoidCallback onMessage;
  final VoidCallback onEndCall;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colors.primary,
            Color.lerp(colors.primary, Colors.black, .52)!,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          MediaQuery.paddingOf(context).top + 20,
          20,
          MediaQuery.paddingOf(context).bottom + 28,
        ),
        child: Column(
          children: <Widget>[
            _CallRoomTopBar(
              title: 'Audio consultation',
              paidMinutes: session.room.paidMinutes,
            ),
            const Spacer(),
            CallParticipantAvatar(name: session.room.clientName),
            const SizedBox(height: 22),
            Text(
              session.room.clientName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            CallStatusText(session: session),
            const Spacer(),
            if (session.phase == CallSessionPhase.ended)
              FilledButton.tonal(
                key: const ValueKey<String>('leave-ended-call-button'),
                onPressed: onLeave,
                child: const Text('Back to app'),
              )
            else
              CallControls(
                isMuted: session.isMuted,
                isSpeakerOn: session.isSpeakerOn,
                onToggleMute: onToggleMute,
                onToggleSpeaker: onToggleSpeaker,
                onMessage: onMessage,
                onEndCall: onEndCall,
              ),
          ],
        ),
      ),
    );
  }
}

class _CallRoomTopBar extends StatelessWidget {
  const _CallRoomTopBar({required this.title, required this.paidMinutes});

  final String title;
  final int paidMinutes;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Icon(Icons.lock_rounded,
              size: 17, color: Theme.of(context).colorScheme.onPrimary),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.surface.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$paidMinutes min paid',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
}
