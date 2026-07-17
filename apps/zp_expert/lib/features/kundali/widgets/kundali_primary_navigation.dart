import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../themes/app_radius.dart';
import '../../../themes/app_spacing.dart';
import '../data/models/kundali_page_section.dart';
import '../data/provider/kundali_page_provider.dart';

class KundaliPrimaryNavigation extends ConsumerWidget {
  const KundaliPrimaryNavigation({super.key});

  static const _items = [
    (label: 'Summary', section: null),
    (label: 'Charts', section: KundaliPageSection.charts),
    (label: 'Planets', section: KundaliPageSection.planets),
    (label: 'Timing', section: KundaliPageSection.timing),
    (label: 'Doshas', section: KundaliPageSection.doshas),
    (label: 'Yogas', section: null),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final selectedSection = ref.watch(kundaliPageSectionProvider);

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
          children: _items.map((item) {
            final selected = item.section == selectedSection;
            final enabled = item.section != null;
            return Semantics(
              selected: selected,
              enabled: enabled,
              button: enabled,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.md),
                onTap: enabled
                    ? () => ref
                        .read(kundaliPageSectionProvider.notifier)
                        .state = item.section!
                    : null,
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
                    item.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: selected
                              ? colors.primary
                              : colors.onSurface.withValues(
                                  alpha: enabled ? 0.58 : 0.36,
                                ),
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w600,
                        ),
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
