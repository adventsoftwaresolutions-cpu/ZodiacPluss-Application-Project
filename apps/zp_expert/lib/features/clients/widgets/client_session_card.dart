import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/app_routes.dart';
import '../../session/data/models/session_history_model.dart';
import '../../session/widgets/session_history_card.dart';
import '../data/models/client_history_model.dart';

class ClientSessionCard extends StatelessWidget {
  const ClientSessionCard({
    required this.session,
    super.key,
    this.onCancel,
  });

  final ClientSessionModel session;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return SessionHistoryCard(
      session: SessionHistoryModel(
        id: session.id,
        type: _sessionType(session.type),
        durationMinutes: session.durationMinutes,
        startedAt: session.scheduledAt,
        earnings: session.earnings,
      ),
      trailingLabel: session.isUpcoming ? 'Booked' : 'Earned',
      trailingColor:
          session.isUpcoming ? Theme.of(context).colorScheme.primary : null,
      actionLabel: session.isUpcoming ? 'Cancel' : null,
      onActionTap: session.isUpcoming ? onCancel : null,
      onTap: session.isUpcoming
          ? null
          : () => context.push(ExpertRoutes.sessionInfoFor(session.id)),
    );
  }

  SessionType _sessionType(ClientSessionType type) {
    switch (type) {
      case ClientSessionType.voice:
        return SessionType.voice;
      case ClientSessionType.chat:
        return SessionType.chat;
      case ClientSessionType.video:
        return SessionType.video;
    }
  }
}
