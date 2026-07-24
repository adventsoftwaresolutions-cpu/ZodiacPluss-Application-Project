import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'kundali_layout.dart';
import '../../data/models/kundali_timing_model.dart';
import 'kundali_info_card.dart';

class KundaliCurrentDashaCard extends StatelessWidget {
  const KundaliCurrentDashaCard({super.key, required this.timing});

  final KundaliTimingData timing;

  @override
  Widget build(BuildContext context) {
    return KundaliInfoCard(
      title: 'Current Dasha',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vimshottari · ${timing.ayanamsa} · '
            '${timing.yearLength}-day year',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.56),
                ),
          ),
          const SizedBox(height: KundaliSpacing.md),
          _MahadashaHero(period: timing.currentMahadasha),
          const SizedBox(height: KundaliSpacing.sm),
          _AntardashaPanel(timing: timing),
          if (timing.nextAntardasha case final next?) ...[
            const SizedBox(height: KundaliSpacing.sm),
            _NextAntardasha(period: next),
          ],
        ],
      ),
    );
  }
}

class _MahadashaHero extends StatelessWidget {
  const _MahadashaHero({required this.period});

  final KundaliDashaPeriod period;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(KundaliRadius.md),
        border: Border.all(color: colors.primary.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          _PlanetAsset(asset: period.asset, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: _PeriodText(
              eyebrow: 'MAHADASHA',
              name: '${period.name} Mahadasha',
              dateRange: _dateRange(period),
            ),
          ),
          _CurrentBadge(color: colors.primary),
        ],
      ),
    );
  }
}

class _AntardashaPanel extends StatelessWidget {
  const _AntardashaPanel({required this.timing});

  final KundaliTimingData timing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final period = timing.currentAntardasha;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(KundaliRadius.md),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _PlanetAsset(asset: period.asset, size: 34),
              const SizedBox(width: 10),
              Expanded(
                child: _PeriodText(
                  eyebrow: 'ANTARDASHA',
                  name: '${period.name} Antardasha',
                  dateRange: _dateRange(period),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(KundaliRadius.sm),
            child: LinearProgressIndicator(
              value: timing.antardashaProgress,
              minHeight: 6,
              color: colors.primary,
              backgroundColor: colors.primary.withValues(alpha: 0.12),
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Text(
                '${(timing.antardashaProgress * 100).round()}% complete',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const Spacer(),
              Text(
                timing.remainingLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextAntardasha extends StatelessWidget {
  const _NextAntardasha({required this.period});

  final KundaliDashaPeriod period;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.arrow_forward_rounded, size: 18, color: colors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Next: ${period.name} Antardasha',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        Text(
          DateFormat('d MMM yyyy').format(period.start),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.58),
              ),
        ),
      ],
    );
  }
}

class _PeriodText extends StatelessWidget {
  const _PeriodText({
    required this.eyebrow,
    required this.name,
    required this.dateRange,
  });

  final String eyebrow;
  final String name;
  final String dateRange;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          dateRange,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.56),
              ),
        ),
      ],
    );
  }
}

class _PlanetAsset extends StatelessWidget {
  const _PlanetAsset({required this.asset, required this.size});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(asset),
    );
  }
}

class _CurrentBadge extends StatelessWidget {
  const _CurrentBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(KundaliRadius.sm),
      ),
      child: Text(
        'Now',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

String _dateRange(KundaliDashaPeriod period) {
  final format = DateFormat('d MMM yyyy');
  return '${format.format(period.start)} – ${format.format(period.end)}';
}
