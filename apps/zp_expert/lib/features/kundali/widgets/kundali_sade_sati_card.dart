import 'package:flutter/material.dart';

import '../../../themes/app_radius.dart';
import '../../../themes/app_spacing.dart';
import '../data/models/kundali_timing_model.dart';
import 'kundali_info_card.dart';

class KundaliSadeSatiCard extends StatelessWidget {
  const KundaliSadeSatiCard({super.key, required this.status});

  final KundaliSadeSatiStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final stateColor = status.isActive ? colors.tertiary : colors.primary;

    return KundaliInfoCard(
      title: 'Sade Sati',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: stateColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.timelapse_rounded,
                  color: stateColor,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.isActive ? 'Currently active' : 'Not active',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status.phase,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: stateColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: stateColor.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text(
              status.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    height: 1.45,
                    color: colors.onSurface.withValues(alpha: 0.72),
                  ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'Calculated from Saturn’s transit relative to the natal Moon.',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.52),
                ),
          ),
        ],
      ),
    );
  }
}
