import 'package:flutter/material.dart';

import 'kundali_shimmer_box.dart';
import 'kundali_layout.dart';

class KundaliDoshasLoading extends StatelessWidget {
  const KundaliDoshasLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        KundaliShimmerBox(
          width: double.infinity,
          height: 120,
          borderRadius: KundaliRadius.lg,
        ),
        SizedBox(height: KundaliSpacing.md),
        KundaliShimmerBox(
          width: double.infinity,
          height: 230,
          borderRadius: KundaliRadius.lg,
        ),
        SizedBox(height: KundaliSpacing.md),
        KundaliShimmerBox(
          width: double.infinity,
          height: 190,
          borderRadius: KundaliRadius.lg,
        ),
        SizedBox(height: KundaliSpacing.md),
        KundaliShimmerBox(
          width: double.infinity,
          height: 230,
          borderRadius: KundaliRadius.lg,
        ),
      ],
    );
  }
}
