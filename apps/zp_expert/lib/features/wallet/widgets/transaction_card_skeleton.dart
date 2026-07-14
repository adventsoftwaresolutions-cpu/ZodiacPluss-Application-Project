import 'package:flutter/material.dart';
import '../../../shared/widgets/shimmer_box.dart';

class TransactionCardSkeleton extends StatelessWidget {
  const TransactionCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: <Widget>[
          ShimmerBox(width: 44, height: 44, borderRadius: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ShimmerBox(width: 120, height: 14),
                SizedBox(height: 6),
                ShimmerBox(width: 90, height: 12),
                SizedBox(height: 6),
                ShimmerBox(width: 100, height: 11),
              ],
            ),
          ),
          SizedBox(width: 8),
          ShimmerBox(width: 60, height: 16),
          SizedBox(width: 8),
          ShimmerBox(width: 32, height: 32, borderRadius: 16),
        ],
      ),
    );
  }
}