import 'package:flutter/material.dart';

import '../../themes/app_radius.dart';
import '../../themes/app_spacing.dart';

class ProgressSectionCard extends StatelessWidget {
  const ProgressSectionCard({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl - 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D3B3E),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          child,
        ],
      ),
    );
  }
}
