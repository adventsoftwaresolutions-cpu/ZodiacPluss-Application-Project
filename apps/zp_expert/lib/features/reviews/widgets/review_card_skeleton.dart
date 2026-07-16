import 'package:flutter/material.dart';

import '../../../shared/widgets/shimmer_box.dart';
import '../../../themes/app_radius.dart';

class ReviewCardSkeleton extends StatelessWidget {
  const ReviewCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                ShimmerBox(width: 44, height: 44, borderRadius: 22),
                SizedBox(width: 11),
                Expanded(child: ShimmerBox(width: 130, height: 16)),
                ShimmerBox(width: 24, height: 24, borderRadius: 12),
              ],
            ),
            SizedBox(height: 13),
            ShimmerBox(width: 110, height: 18),
            SizedBox(height: 12),
            ShimmerBox(width: double.infinity, height: 13),
            SizedBox(height: 8),
            ShimmerBox(width: 240, height: 13),
            SizedBox(height: 14),
            ShimmerBox(width: 190, height: 12),
          ],
        ),
      );
}
