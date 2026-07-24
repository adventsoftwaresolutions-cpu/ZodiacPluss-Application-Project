import 'package:flutter/material.dart';

import '../kundali_theme.dart';
import 'kundali_layout.dart';
import '../../data/models/kundali_dosha_model.dart';
import 'kundali_info_card.dart';

class KundaliDoshaResultCard extends StatelessWidget {
  const KundaliDoshaResultCard({super.key, required this.result});

  final KundaliDoshaResult result;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final statusColor = result.hasDosha
        ? colors.error
        : KundaliThemeData.resolve(context).successColor!;

    return KundaliInfoCard(
      title: result.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusIcon(
                isDetected: result.hasDosha,
                color: statusColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatusText(result: result, color: statusColor),
              ),
              if (result.type case final type?)
                _TypeBadge(label: type, color: statusColor),
            ],
          ),
          const SizedBox(height: KundaliSpacing.md),
          Text(
            result.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.45,
                  color: colors.onSurface.withValues(alpha: 0.72),
                ),
          ),
          if (result.exceptions.isNotEmpty) ...[
            const SizedBox(height: KundaliSpacing.sm),
            _ExceptionDetails(result: result),
          ],
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.isDetected, required this.color});

  final bool isDetected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isDetected ? Icons.priority_high_rounded : Icons.check_rounded,
        color: color,
        size: 21,
      ),
    );
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText({required this.result, required this.color});

  final KundaliDoshaResult result;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          result.hasDosha ? 'Detected' : 'Not detected',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          result.hasException
              ? 'Cancellation conditions found'
              : 'Based on the calculated chart',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.54),
              ),
        ),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(KundaliRadius.sm),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _ExceptionDetails extends StatelessWidget {
  const _ExceptionDetails({required this.result});

  final KundaliDoshaResult result;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(KundaliRadius.md),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 10),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          'Calculation details',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        children: result.exceptions
            .map((exception) => _DetailBullet(text: exception))
            .toList(growable: false),
      ),
    );
  }
}

class _DetailBullet extends StatelessWidget {
  const _DetailBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Icon(Icons.circle, size: 5, color: colors.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    height: 1.4,
                    color: colors.onSurface.withValues(alpha: 0.66),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
