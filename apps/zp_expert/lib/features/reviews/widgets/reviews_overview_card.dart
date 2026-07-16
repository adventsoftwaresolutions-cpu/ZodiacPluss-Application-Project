import 'package:flutter/material.dart';

import '../../../themes/app_radius.dart';

class ReviewsOverviewCard extends StatelessWidget {
  const ReviewsOverviewCard({
    required this.averageRating,
    required this.totalReviews,
    super.key,
  });

  final double averageRating;
  final int totalReviews;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget average = _SummaryMetric(
              icon: Icons.star_rounded,
              value: averageRating.toStringAsFixed(1),
              label: 'Average rating',
              showStars: true,
            );
            final Widget total = _SummaryMetric(
              icon: Icons.chat_bubble_outline_rounded,
              value: '$totalReviews',
              label: 'Total reviews',
            );

            if (constraints.maxWidth < 420) {
              return Column(
                children: <Widget>[
                  average,
                  const Divider(height: 26),
                  total,
                ],
              );
            }
            return Row(
              children: <Widget>[
                Expanded(child: average),
                const SizedBox(
                  height: 72,
                  child: VerticalDivider(width: 30),
                ),
                Expanded(child: total),
              ],
            );
          },
        ),
      );
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.icon,
    required this.value,
    required this.label,
    this.showStars = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool showStars;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return Row(
      children: <Widget>[
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: .13),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: primary, size: 29),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0D3B3E),
                    ),
              ),
              if (showStars)
                const Row(
                  children: <Widget>[
                    Icon(Icons.star_rounded,
                        size: 14, color: Color(0xFFFFB020)),
                    Icon(Icons.star_rounded,
                        size: 14, color: Color(0xFFFFB020)),
                    Icon(Icons.star_rounded,
                        size: 14, color: Color(0xFFFFB020)),
                    Icon(Icons.star_rounded,
                        size: 14, color: Color(0xFFFFB020)),
                    Icon(Icons.star_half_rounded,
                        size: 14, color: Color(0xFFFFB020)),
                  ],
                ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
