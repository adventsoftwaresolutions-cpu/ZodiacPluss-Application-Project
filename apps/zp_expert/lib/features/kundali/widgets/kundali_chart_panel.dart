import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../themes/app_radius.dart';
import '../../../themes/app_spacing.dart';
import '../data/models/kundali_chart_model.dart';
import '../data/provider/kundali_chart_provider.dart';
import 'kundali_chart_reveal.dart';
import 'kundali_loading_skeleton.dart';
import 'kundali_reference_cards.dart';

class KundaliChartsBody extends ConsumerWidget {
  const KundaliChartsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(kundaliChartSelectionProvider);
    final chart = ref.watch(kundaliChartProvider(selection));

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        0,
        12,
        AppSpacing.lg,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: chart.when(
          data: (data) => Column(
            key: ValueKey('kundali-${selection.hashCode}'),
            children: [
              KundaliChartPanel(selection: selection, data: data),
              const SizedBox(height: 12),
              PlanetShortFormsCard(items: data.planetShortForms),
              const SizedBox(height: 12),
              CommonShortFormsCard(items: data.commonShortForms),
              const SizedBox(height: 12),
              HowToReadChartCard(tips: data.readingTips),
            ],
          ),
          loading: () => const KundaliLoadingSkeleton(
            key: ValueKey('kundali-loading'),
          ),
          error: (error, stackTrace) => _ChartError(
            key: const ValueKey('kundali-error'),
            onRetry: () => ref.invalidate(kundaliChartProvider(selection)),
          ),
        ),
      ),
    );
  }
}

class KundaliChartPanel extends ConsumerWidget {
  const KundaliChartPanel({
    super.key,
    required this.selection,
    required this.data,
  });

  final KundaliChartRequest selection;
  final KundaliChartData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final notifier = ref.read(kundaliChartSelectionProvider.notifier);

    return Container(
      clipBehavior: Clip.antiAlias,
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
      child: Column(
        children: [
          _SectionTabs(
            selected: selection.section,
            onSelected: notifier.selectSection,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const _SelectionGroupLabel(label: 'Chart layout'),
                const SizedBox(height: 6),
                _StyleSelector(
                  selected: selection.style,
                  onSelected: notifier.selectStyle,
                ),
                if (selection.section == KundaliChartSection.divisional) ...[
                  const SizedBox(height: 12),
                  const _PartialSectionDivider(label: 'Divisional chart'),
                  const SizedBox(height: 12),
                  _DivisionSelector(
                    selected: selection.division,
                    onSelected: notifier.selectDivision,
                  ),
                ],
                const SizedBox(height: 12),
                _ChartHeading(title: data.title, subtitle: data.subtitle),
                const SizedBox(height: 6),
                FractionallySizedBox(
                  widthFactor: 0.90,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: KundaliChartReveal(
                      svg: data.svg,
                      style: selection.style,
                      semanticsLabel:
                          '${data.title} ${selection.style.label} Kundali chart',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({required this.selected, required this.onSelected});

  final KundaliChartSection selected;
  final ValueChanged<KundaliChartSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: KundaliChartSection.values.map((section) {
        final isSelected = section == selected;
        return Expanded(
          child: InkWell(
            onTap: () => onSelected(section),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? colors.primary : colors.outlineVariant,
                    width: isSelected ? 3 : 1,
                  ),
                ),
              ),
              child: Text(
                section.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? colors.primary
                          : colors.onSurface.withValues(alpha: 0.62),
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
              ),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }
}

class _StyleSelector extends StatelessWidget {
  const _StyleSelector({required this.selected, required this.onSelected});

  final KundaliChartStyle selected;
  final ValueChanged<KundaliChartStyle> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: KundaliChartStyle.values.map((style) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: _ChoicePill(
              label: style.label,
              selected: style == selected,
              onTap: () => onSelected(style),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }
}

class _DivisionSelector extends StatelessWidget {
  const _DivisionSelector({required this.selected, required this.onSelected});

  final KundaliDivision selected;
  final ValueChanged<KundaliDivision> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: KundaliDivision.values.map((division) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: _DivisionCard(
              division: division,
              selected: division == selected,
              onTap: () => onSelected(division),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }
}

class _DivisionCard extends StatelessWidget {
  const _DivisionCard({
    required this.division,
    required this.selected,
    required this.onTap,
  });

  final KundaliDivision division;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? colors.primary : colors.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              division.shortLabel,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: selected ? colors.onPrimary : colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              division.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected
                        ? colors.onPrimary.withValues(alpha: 0.84)
                        : colors.onSurface.withValues(alpha: 0.62),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionGroupLabel extends StatelessWidget {
  const _SelectionGroupLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.62),
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _PartialSectionDivider extends StatelessWidget {
  const _PartialSectionDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(child: Divider(color: colors.outlineVariant, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        Expanded(child: Divider(color: colors.outlineVariant, height: 1)),
      ],
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.06)
              : colors.surfaceContainerHighest.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: selected ? colors.primary : colors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: selected
                    ? colors.primary
                    : colors.onSurface.withValues(alpha: 0.65),
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class _ChartHeading extends StatelessWidget {
  const _ChartHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.58),
              ),
        ),
      ],
    );
  }
}

class _ChartError extends StatelessWidget {
  const _ChartError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40),
            const SizedBox(height: AppSpacing.sm),
            const Text('Unable to load this chart.'),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
