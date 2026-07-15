import 'package:flutter/material.dart';

import '../../../shared/widgets/shimmer_box.dart';
import '../../../themes/app_radius.dart';

class SessionHistoryCardSkeleton extends StatelessWidget {
  const SessionHistoryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 13,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ShimmerBox(width: 54, height: 54, borderRadius: 12),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ShimmerBox(width: 104, height: 17),
                    SizedBox(height: 8),
                    ShimmerBox(width: 74, height: 13),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  ShimmerBox(width: 55, height: 14),
                  SizedBox(height: 7),
                  ShimmerBox(width: 42, height: 17),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              ShimmerBox(width: 18, height: 18, borderRadius: 9),
              SizedBox(width: 8),
              ShimmerBox(width: 190, height: 13),
            ],
          ),
        ],
      ),
    );
  }
}
