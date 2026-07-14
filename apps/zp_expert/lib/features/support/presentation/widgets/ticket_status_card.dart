import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../shared/constans/app_assets.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radius.dart';
import '../../../../themes/app_spacing.dart';
import 'ticket_styles.dart';

class TicketStatusCard extends StatelessWidget {
  const TicketStatusCard({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.white.withValues(alpha: .95),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: <Widget>[
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: AppColors.ticketField,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Center(
                    child: SvgPicture.asset(AppAssets.ticketIcon,
                        width: 24, height: 24),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Ticket Status', style: TicketStyles.statusTitle),
                      SizedBox(height: 2),
                      Text('Track your ticket and view all updates',
                          style: TicketStyles.statusSubtitle),
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary),
              ],
            ),
          ),
        ),
      );
}
