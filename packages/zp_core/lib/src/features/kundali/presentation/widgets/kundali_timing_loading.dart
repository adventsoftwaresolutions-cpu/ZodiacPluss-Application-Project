import 'package:flutter/material.dart';

import 'kundali_shimmer_box.dart';
import 'kundali_layout.dart';

class KundaliTimingLoading extends StatelessWidget {
  const KundaliTimingLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        KundaliShimmerBox(
          width: double.infinity,
          height: 310,
          borderRadius: KundaliRadius.lg,
        ),
        SizedBox(height: KundaliSpacing.md),
        KundaliShimmerBox(
          width: double.infinity,
          height: 400,
          borderRadius: KundaliRadius.lg,
        ),
        SizedBox(height: KundaliSpacing.md),
        KundaliShimmerBox(
          width: double.infinity,
          height: 220,
          borderRadius: KundaliRadius.lg,
        ),
      ],
    );
  }
}
