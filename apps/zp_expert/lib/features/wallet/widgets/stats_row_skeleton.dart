import 'package:flutter/material.dart';
import 'package:zp_expert/features/wallet/widgets/stat_card_skeleton.dart';

class StatsRowSkeleton extends StatelessWidget {
  const StatsRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: StatCardSkeleton()),
            SizedBox(width: 12),
            Expanded(child: StatCardSkeleton()),
            SizedBox(width: 12),
            Expanded(child: StatCardSkeleton()),
          ],
        ),
      );
}
