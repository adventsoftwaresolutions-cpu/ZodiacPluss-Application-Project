import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FailedHeader extends StatelessWidget {
  const FailedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        SvgPicture.asset(
          'assets/icons/cross.svg',
          width: 78,
          height: 78,
        ),

        const SizedBox(height: 20),

        Text(
          'Verification Failed!',
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'We are sorry! Your information could not be verified automatically.\n'
          'Our team is now reviewing your details.',
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