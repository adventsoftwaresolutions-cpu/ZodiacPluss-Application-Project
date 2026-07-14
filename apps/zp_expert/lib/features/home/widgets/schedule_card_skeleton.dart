import 'package:flutter/material.dart';
import '../../../shared/widgets/shimmer_box.dart';

class ScheduleCardSkeleton extends StatelessWidget {
  const ScheduleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(3, (int i) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Row(
            children: <Widget>[
              ShimmerBox(width: 48, height: 48, borderRadius: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ShimmerBox(width: 140, height: 14),
                    SizedBox(height: 6),
                    ShimmerBox(width: 100, height: 12),
                  ],
                ),
              ),
              SizedBox(width: 8),
              ShimmerBox(width: 60, height: 28, borderRadius: 8),
            ],
          ),
        );
      }),
    );
  }
}