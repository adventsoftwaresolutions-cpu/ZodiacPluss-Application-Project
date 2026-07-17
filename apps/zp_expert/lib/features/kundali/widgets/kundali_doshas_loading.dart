import 'package:flutter/material.dart';

import '../../../shared/widgets/shimmer_box.dart';
import '../../../themes/app_radius.dart';
import '../../../themes/app_spacing.dart';

class KundaliDoshasLoading extends StatelessWidget {
  const KundaliDoshasLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(
          width: double.infinity,
          height: 120,
          borderRadius: AppRadius.lg,
        ),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(
          width: double.infinity,
          height: 230,
          borderRadius: AppRadius.lg,
        ),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(
          width: double.infinity,
          height: 190,
          borderRadius: AppRadius.lg,
        ),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(
          width: double.infinity,
          height: 230,
          borderRadius: AppRadius.lg,
        ),
      ],
    );
  }
}
