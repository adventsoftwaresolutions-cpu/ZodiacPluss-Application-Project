import 'package:flutter/material.dart';

import '../../../shared/widgets/shimmer_box.dart';
import '../../../themes/app_radius.dart';

class ChatThreadCardSkeleton extends StatelessWidget {
  const ChatThreadCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Row(
          children: <Widget>[
            ShimmerBox(width: 54, height: 54, borderRadius: 27),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ShimmerBox(width: 125, height: 15),
                  SizedBox(height: 8),
                  ShimmerBox(width: double.infinity, height: 12),
                  SizedBox(height: 10),
                  ShimmerBox(width: 92, height: 18, borderRadius: 9),
                ],
              ),
            ),
            SizedBox(width: 10),
            ShimmerBox(width: 42, height: 11),
          ],
        ),
      );
}
