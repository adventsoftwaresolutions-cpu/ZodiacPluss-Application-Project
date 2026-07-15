import 'package:flutter/material.dart';

import '../../../shared/widgets/shimmer_box.dart';

class ProfileLoadingSkeleton extends StatelessWidget {
  const ProfileLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
        children: const <Widget>[
          Row(
            children: <Widget>[
              ShimmerBox(width: 44, height: 44, borderRadius: 22),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ShimmerBox(width: 164, height: 24),
                    SizedBox(height: 7),
                    ShimmerBox(width: 205, height: 14),
                  ],
                ),
              ),
              ShimmerBox(width: 78, height: 36),
            ],
          ),
          SizedBox(height: 28),
          Row(
            children: <Widget>[
              ShimmerBox(width: 92, height: 92, borderRadius: 46),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ShimmerBox(width: 112, height: 24),
                    SizedBox(height: 8),
                    ShimmerBox(width: 84, height: 20),
                    SizedBox(height: 8),
                    ShimmerBox(width: 180, height: 14),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _CardSkeleton(height: 142),
          SizedBox(height: 16),
          _CardSkeleton(height: 210),
          SizedBox(height: 16),
          _CardSkeleton(height: 142),
          SizedBox(height: 16),
          _CardSkeleton(height: 190),
        ],
      );
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ShimmerBox(width: 164, height: 20),
            SizedBox(height: 16),
            ShimmerBox(width: double.infinity, height: 14),
            SizedBox(height: 9),
            ShimmerBox(width: 245, height: 14),
          ],
        ),
      );
}
