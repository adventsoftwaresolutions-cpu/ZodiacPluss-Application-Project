import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import '../data/models/session_history_model.dart';

class SessionHistoryCard extends StatefulWidget {
  const SessionHistoryCard({required this.session, super.key});

  final SessionHistoryModel session;

  @override
  State<SessionHistoryCard> createState() => _SessionHistoryCardState();
}

class _SessionHistoryCardState extends State<SessionHistoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final SessionHistoryModel session = widget.session;

    return AnimatedScale(
      scale: _isPressed ? .985 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0x14000000),
              blurRadius: _isPressed ? 7 : 13,
              offset: Offset(0, _isPressed ? 3 : 6),
            ),
          ],
        ),
        child: Material(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: HapticFeedback.selectionClick,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _SessionIcon(icon: _sessionIcon(session.type)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              session.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: colors.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            _DetailLine(
                              icon: Icons.timer_outlined,
                              label: '${session.durationMinutes} min',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Earned',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      colors.onSurface.withValues(alpha: .66),
                                ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '₹${session.earnings}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.ticketResolved,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: colors.onSurface.withValues(alpha: .48),
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  _DetailLine(
                    icon: Icons.calendar_month_outlined,
                    label: DateFormat('d MMM, y, h:mm a')
                        .format(session.startedAt),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _sessionIcon(SessionType type) {
    switch (type) {
      case SessionType.voice:
        return Icons.phone_in_talk_outlined;
      case SessionType.chat:
        return Icons.chat_bubble_outline_rounded;
      case SessionType.video:
        return Icons.videocam_outlined;
    }
  }
}

class _SessionIcon extends StatelessWidget {
  const _SessionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(icon, color: AppColors.primary, size: 30),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final Color color =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: .56);

    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
