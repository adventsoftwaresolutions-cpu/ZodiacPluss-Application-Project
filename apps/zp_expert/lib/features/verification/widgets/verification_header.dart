import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/constants/app_assets.dart';

class VerificationHeader extends StatelessWidget {
  const VerificationHeader({required this.onSkip, super.key});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                key: const ValueKey<String>('verification-skip-button'),
                onPressed: onSkip,
                icon: const Icon(Icons.skip_next_rounded, size: 18),
                label: const Text('Skip'),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Complete your profile',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff111827),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'A few quick steps to help clients discover the right expert.',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: const Color(0xff6B7280),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: SvgPicture.asset(
            AppAssets.shieldIcon,
            width: 64,
            height: 64,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
