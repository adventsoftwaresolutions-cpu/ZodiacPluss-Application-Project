import 'package:flutter/material.dart';
import '../../../shared/widgets/shimmer_box.dart';

class PerformanceCardSkeleton extends StatelessWidget {
  const PerformanceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(7, (int i) {
        final bool isLast = i == 6;
        return Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: <Widget>[
                  ShimmerBox(width: 44, height: 44, borderRadius: 14),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ShimmerBox(width: 120, height: 14),
                        SizedBox(height: 6),
                        ShimmerBox(width: 90, height: 12),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  ShimmerBox(width: 44, height: 18),
                ],
              ),
            ),
            if (!isLast) const Divider(height: 1),
          ],
        );
      }),
    );
  }
}