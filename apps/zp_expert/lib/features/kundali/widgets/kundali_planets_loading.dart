import 'package:flutter/material.dart';

import '../../../shared/widgets/shimmer_box.dart';
import '../../../themes/app_radius.dart';
import '../../../themes/app_spacing.dart';

class KundaliPlanetsLoading extends StatelessWidget {
  const KundaliPlanetsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(
          width: double.infinity,
          height: 620,
          borderRadius: AppRadius.lg,
        ),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(
          width: double.infinity,
          height: 330,
          borderRadius: AppRadius.lg,
        ),
      ],
    );
  }
}
