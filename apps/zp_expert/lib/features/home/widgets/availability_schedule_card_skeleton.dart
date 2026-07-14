import 'package:flutter/material.dart';
import '../../../shared/widgets/shimmer_box.dart';

class AvailabilityScheduleCardSkeleton extends StatelessWidget {
  const AvailabilityScheduleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ...List<Widget>.generate(7, (int i) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 90,
                  child: Padding(
                    padding: EdgeInsets.only(top: 14),
                    child: ShimmerBox(width: 60, height: 14),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15),
                      ShimmerBox(width: double.infinity, height: 36, borderRadius: 10),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15),
                      ShimmerBox(width: double.infinity, height: 36, borderRadius: 10),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: ShimmerBox(width: 40, height: 24, borderRadius: 12),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        const ShimmerBox(width: double.infinity, height: 52, borderRadius: 14),
      ],
    );
  }
}