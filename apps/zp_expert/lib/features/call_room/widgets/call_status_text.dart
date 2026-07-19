import 'package:flutter/material.dart';

import '../data/models/call_room_model.dart';

class CallStatusText extends StatelessWidget {
  const CallStatusText({required this.session, super.key});

  final CallSessionState session;

  @override
  Widget build(BuildContext context) {
    final String status = switch (session.phase) {
      CallSessionPhase.waitingForClient =>
        'Waiting for client · ${_clock(session.elapsedSeconds)}',
      CallSessionPhase.connected => _clock(session.elapsedSeconds),
      CallSessionPhase.reconnecting =>
        'Reconnecting · ${_clock(session.elapsedSeconds)}',
      CallSessionPhase.ended =>
        session.endedAutomatically ? 'Call ended automatically' : 'Call ended',
    };
    return SizedBox(
      height: 20,
      child: Center(
        child: Text(
          status,
          key: const ValueKey<String>('call-status-text'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color:
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: .78),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _clock(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainder = seconds % 60;
    return '$minutes:${remainder.toString().padLeft(2, '0')}';
  }
}
