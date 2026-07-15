import 'package:flutter/material.dart';

import '../../../shared/widgets/shimmer_box.dart';

class PricingContentSkeleton extends StatelessWidget {
  const PricingContentSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ShimmerBox(width: double.infinity, height: 76, borderRadius: 16),
            SizedBox(height: 24),
            ShimmerBox(width: 136, height: 20),
            SizedBox(height: 6),
            ShimmerBox(width: 170, height: 15),
            SizedBox(height: 12),
            _PlanSkeleton(),
            SizedBox(height: 16),
            _PlanSkeleton(),
          ],
        ),
      );
}

class _PlanSkeleton extends StatelessWidget {
  const _PlanSkeleton();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: const Color(0xFF76C5D0)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Column(
          children: <Widget>[
            Row(children: <Widget>[
              ShimmerBox(width: 50, height: 50, borderRadius: 25),
              SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    ShimmerBox(width: 100, height: 18),
                    SizedBox(height: 6),
                    ShimmerBox(width: 170, height: 14)
                  ]))
            ]),
            SizedBox(height: 18),
            _PricingRowSkeleton(),
            SizedBox(height: 10),
            _PricingRowSkeleton(),
            SizedBox(height: 10),
            _PricingRowSkeleton(),
          ],
        ),
      );
}

class _PricingRowSkeleton extends StatelessWidget {
  const _PricingRowSkeleton();

  @override
  Widget build(BuildContext context) => const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ShimmerBox(width: 46, height: 16),
            SizedBox(height: 5),
            Row(children: <Widget>[
              Expanded(child: ShimmerBox(width: double.infinity, height: 44)),
              SizedBox(width: 12),
              Expanded(child: ShimmerBox(width: double.infinity, height: 44))
            ])
          ]);
}
