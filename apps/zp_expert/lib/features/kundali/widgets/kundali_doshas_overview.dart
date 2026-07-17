import 'package:flutter/material.dart';

import '../../../themes/app_radius.dart';
import '../data/models/kundali_dosha_model.dart';
import 'kundali_info_card.dart';

class KundaliDoshasOverview extends StatelessWidget {
  const KundaliDoshasOverview({super.key, required this.data});

  final KundaliDoshasData data;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return KundaliInfoCard(
      title: 'Dosha Analysis',
      child: Row(
        children: [
          _DetectedCountBadge(count: data.detectedDoshaCount),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.detectedDoshaCount} of 2 doshas detected',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Mangal and Kaal Sarp · ${data.ayanamsa} ayanamsa',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.58),
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              '3 checks',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetectedCountBadge extends StatelessWidget {
  const _DetectedCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: '$count detected doshas',
      child: Container(
        key: const ValueKey('dosha-detected-count'),
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.10),
          shape: BoxShape.circle,
          border: Border.all(color: colors.primary.withValues(alpha: 0.22)),
        ),
        child: Text(
          '$count',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}
