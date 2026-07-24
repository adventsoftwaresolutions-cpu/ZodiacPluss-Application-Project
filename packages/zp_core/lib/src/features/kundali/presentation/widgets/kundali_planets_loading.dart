import 'package:flutter/material.dart';

import 'kundali_shimmer_box.dart';
import 'kundali_layout.dart';

class KundaliPlanetsLoading extends StatelessWidget {
  const KundaliPlanetsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        KundaliShimmerBox(
          width: double.infinity,
          height: 620,
          borderRadius: KundaliRadius.lg,
        ),
        SizedBox(height: KundaliSpacing.md),
        KundaliShimmerBox(
          width: double.infinity,
          height: 330,
          borderRadius: KundaliRadius.lg,
        ),
      ],
    );
  }
}
