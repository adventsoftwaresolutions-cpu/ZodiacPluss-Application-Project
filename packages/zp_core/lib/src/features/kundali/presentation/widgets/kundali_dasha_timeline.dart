import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'kundali_layout.dart';
import '../../data/models/kundali_timing_model.dart';
import 'kundali_info_card.dart';

class KundaliDashaTimeline extends StatelessWidget {
  const KundaliDashaTimeline({super.key, required this.timing});

  final KundaliTimingData timing;

  @override
  Widget build(BuildContext context) {
    return KundaliInfoCard(
      title: 'Mahadasha Timeline',
      child: Column(
        children: timing.timeline
            .map(
              (period) => _MahadashaEntry(
                period: period,
                currentMahadasha: timing.currentMahadasha,
                currentAntardasha: timing.currentAntardasha,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _MahadashaEntry extends StatelessWidget {
  const _MahadashaEntry({
    required this.period,
    required this.currentMahadasha,
    required this.currentAntardasha,
  });

  final KundaliDashaPeriod period;
  final KundaliDashaPeriod currentMahadasha;
  final KundaliDashaPeriod currentAntardasha;

  bool get isCurrent => period == currentMahadasha;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final header = _TimelineHeader(period: period, isCurrent: isCurrent);
    if (period.subPeriods.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: header,
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: isCurrent
            ? colors.primary.withValues(alpha: 0.07)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(KundaliRadius.md),
        border: Border.all(
          color: isCurrent
              ? colors.primary.withValues(alpha: 0.24)
              : colors.outlineVariant.withValues(alpha: 0.65),
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: isCurrent,
        tilePadding: const EdgeInsets.symmetric(horizontal: 10),
        childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: colors.primary,
        collapsedIconColor: colors.onSurface.withValues(alpha: 0.48),
        title: header,
        children: period.subPeriods
            .map(
              (subPeriod) => _AntardashaRow(
                period: subPeriod,
                isCurrent: subPeriod == currentAntardasha,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _TimelineHeader extends StatelessWidget {
  const _TimelineHeader({required this.period, required this.isCurrent});

  final KundaliDashaPeriod period;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        SvgPicture.asset(period.asset, width: 25, height: 25),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${period.name} Mahadasha',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                _dateRange(period),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.55),
                    ),
              ),
            ],
          ),
        ),
        if (isCurrent)
          Icon(Icons.radio_button_checked, color: colors.primary, size: 17),
      ],
    );
  }
}

class _AntardashaRow extends StatelessWidget {
  const _AntardashaRow({required this.period, required this.isCurrent});

  final KundaliDashaPeriod period;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrent
            ? colors.primary.withValues(alpha: 0.12)
            : colors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(KundaliRadius.sm),
      ),
      child: Row(
        children: [
          SvgPicture.asset(period.asset, width: 19, height: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${period.name} Antardasha',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isCurrent ? colors.primary : null,
                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                  ),
            ),
          ),
          Text(
            DateFormat('MMM yyyy').format(period.start),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.54),
                ),
          ),
        ],
      ),
    );
  }
}

String _dateRange(KundaliDashaPeriod period) {
  final format = DateFormat('MMM yyyy');
  return '${format.format(period.start)} – ${format.format(period.end)}';
}
