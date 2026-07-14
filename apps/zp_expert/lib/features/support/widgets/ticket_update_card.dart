import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../shared/constants/app_assets.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import '../data/ticket_model.dart';

class TicketUpdateCard extends StatelessWidget {
  const TicketUpdateCard({required this.ticket, super.key});

  final SupportTicket ticket;

  bool get _isPayment => ticket.category == 'Payment & wallet';

  IconData get _statusIcon => switch (ticket.progress) {
        TicketProgress.all => Icons.layers_outlined,
        TicketProgress.inProgress => Icons.access_time_rounded,
        TicketProgress.resolved => Icons.check_circle_outline_rounded,
        TicketProgress.closed => Icons.cancel_outlined,
      };

  Color get _statusColor => switch (ticket.progress) {
        TicketProgress.inProgress => AppColors.primary,
        TicketProgress.resolved => AppColors.ticketResolved,
        TicketProgress.closed => AppColors.ticketClosed,
        TicketProgress.all => AppColors.primary,
      };

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              AppColors.white,
              AppColors.white.withValues(alpha: .91),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.white.withValues(alpha: .78)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .07),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 48,
                  width: 48,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: SvgPicture.asset(
                    _isPayment ? AppAssets.walletIcon : AppAssets.calendarIcon,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ticket.subject,
                        style: const TextStyle(
                          color: AppColors.ticketText,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ticket.id,
                        style: const TextStyle(
                          color: AppColors.mutedText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _ProgressPill(
                  progress: ticket.progress,
                  icon: _statusIcon,
                  color: _statusColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.ticketField.withValues(alpha: .58),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      const Text(
                        'Latest Updates',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    ticket.latestUpdate ?? ticket.description,
                    style: const TextStyle(
                      color: AppColors.ticketText,
                      fontSize: 14,
                      height: 1.32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                const Icon(Icons.schedule_outlined,
                    size: 15, color: AppColors.mutedText),
                const SizedBox(width: 6),
                Text(
                  'Raised on ${DateFormat('d MMM, yyyy   h:mma').format(ticket.createdAt)}',
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _ProgressPill extends StatelessWidget {
  const _ProgressPill({
    required this.progress,
    required this.icon,
    required this.color,
  });

  final TicketProgress progress;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 5),
            Text(
              progress.label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
}
