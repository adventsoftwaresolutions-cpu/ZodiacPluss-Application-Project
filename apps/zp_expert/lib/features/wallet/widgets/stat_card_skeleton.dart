import 'package:flutter/material.dart';
import 'package:zp_expert/shared/widgets/shimmer_box.dart';

class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: <Widget>[
          ShimmerBox(width: 56, height: 56, borderRadius: 28),
          SizedBox(height: 12),
          ShimmerBox(width: 80, height: 13),
          SizedBox(height: 8),
          ShimmerBox(width: 60, height: 22),
          SizedBox(height: 4),
          ShimmerBox(width: 50, height: 12),
        ],
      ),
    );
  }
}