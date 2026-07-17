import 'package:flutter/material.dart';

import '../../../themes/app_radius.dart';
import '../../../themes/app_spacing.dart';

class KundaliPrimaryNavigation extends StatelessWidget {
  const KundaliPrimaryNavigation({super.key});

  static const _items = [
    'Summary',
    'Charts',
    'Planets',
    'Timing',
    'Doshas',
    'Yogas',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        12,
        AppSpacing.md,
        6,
      ),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _items.map((label) {
            final selected = label == 'Charts';
            return Semantics(
              selected: selected,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? colors.primary.withValues(alpha: 0.10)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: selected
                            ? colors.primary
                            : colors.onSurface.withValues(alpha: 0.58),
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w600,
                      ),
                ),
              ),
            );
          }).toList(growable: false),
        ),
      ),
    );
  }
}
