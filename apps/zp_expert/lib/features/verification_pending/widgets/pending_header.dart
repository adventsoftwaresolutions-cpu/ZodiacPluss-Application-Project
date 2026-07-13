import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PendingHeader extends StatelessWidget {
  const PendingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Transform.translate(
          offset: const Offset(0, -22),
          child: SvgPicture.asset(
            'assets/icons/verification.svg',
            width: 68,
            height: 68,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Verification in Progress',
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Thank you! Your information has been submitted successfully. '
          'Our team is reviewing your details. This usually takes 24–48 hours.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}