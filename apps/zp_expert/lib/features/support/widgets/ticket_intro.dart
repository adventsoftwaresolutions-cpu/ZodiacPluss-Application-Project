import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/constants/app_assets.dart';
import '../../../themes/app_colors.dart';
import 'ticket_styles.dart';

class TicketIntro extends StatelessWidget {
  const TicketIntro({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 104,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              right: 12,
              top: 4,
              child: IgnorePointer(
                child: Transform.rotate(
                  angle: 83 * math.pi / 180,
                  child: Opacity(
                    opacity: .20,
                    child: SvgPicture.asset(
                      AppAssets.ticketIcon,
                      width: 112,
                      height: 92,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: .55),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.ticketIcon,
                      width: 21,
                      height: 21,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Create a New ticket',
                          style: TicketStyles.cardTitle),
                      SizedBox(height: 2),
                      Text(
                        'Select your category, provide details\nand submit your ticket',
                        style: TicketStyles.cardSubtitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
