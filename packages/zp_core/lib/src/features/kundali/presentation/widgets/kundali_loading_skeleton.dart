import 'package:flutter/material.dart';

import 'kundali_shimmer_box.dart';
import 'kundali_layout.dart';

class KundaliLoadingSkeleton extends StatelessWidget {
  const KundaliLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SkeletonCard(
          child: Column(
            children: [
              const _SkeletonTabs(count: 4, height: 12),
              const SizedBox(height: KundaliSpacing.md),
              const _SkeletonTabs(count: 3, height: 34),
              const SizedBox(height: KundaliSpacing.md),
              const KundaliShimmerBox(width: 126, height: 12, borderRadius: 6),
              const SizedBox(height: KundaliSpacing.sm),
              LayoutBuilder(
                builder: (context, constraints) {
                  final chartSize = constraints.maxWidth * 0.82;
                  return KundaliShimmerBox(
                    width: chartSize,
                    height: chartSize,
                    borderRadius: KundaliRadius.lg,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: KundaliSpacing.md),
        const KundaliShimmerBox(
          width: double.infinity,
          height: 104,
          borderRadius: KundaliRadius.lg,
        ),
        const SizedBox(height: KundaliSpacing.md),
        const KundaliShimmerBox(
          width: double.infinity,
          height: 150,
          borderRadius: KundaliRadius.lg,
        ),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(KundaliRadius.lg),
      ),
      child: child,
    );
  }
}

class _SkeletonTabs extends StatelessWidget {
  const _SkeletonTabs({required this.count, required this.height});

  final int count;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: KundaliShimmerBox(
              width: double.infinity,
              height: height,
              borderRadius: height / 3,
            ),
          ),
        );
      }),
    );
  }
}
