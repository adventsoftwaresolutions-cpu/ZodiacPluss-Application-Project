import 'package:flutter/material.dart';

import '../../../shared/widgets/shimmer_box.dart';
import '../../../themes/app_radius.dart';
import '../../../themes/app_spacing.dart';

class KundaliTimingLoading extends StatelessWidget {
  const KundaliTimingLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(
          width: double.infinity,
          height: 310,
          borderRadius: AppRadius.lg,
        ),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(
          width: double.infinity,
          height: 400,
          borderRadius: AppRadius.lg,
        ),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(
          width: double.infinity,
          height: 220,
          borderRadius: AppRadius.lg,
        ),
      ],
    );
  }
}
