import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MaxAttemptHeader extends StatelessWidget {
  const MaxAttemptHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        SvgPicture.asset(
          'assets/icons/maxattempt.svg',
          width: 78,
          height: 78,
          fit: BoxFit.contain,
          colorFilter: null,
        ),

        const SizedBox(height: 20),

        Text(
          'Maximum Attempts Reached',
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'You have used all 3 verification attempts.\n'
          'Please contact our support team for assistance before trying again.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}