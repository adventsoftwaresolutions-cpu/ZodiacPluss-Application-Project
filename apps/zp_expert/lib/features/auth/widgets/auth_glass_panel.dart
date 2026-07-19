import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../themes/app_radius.dart';
import '../../../themes/app_spacing.dart';

class AuthGlassPanel extends StatelessWidget {
  const AuthGlassPanel({
    required this.child,
    this.blurSigma = defaultBlurSigma,
    super.key,
  });

  static const double defaultBlurSigma = 20;

  final Widget child;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final BorderRadius borderRadius = BorderRadius.circular(AppRadius.xl + 8);
    final double horizontalPadding =
        MediaQuery.sizeOf(context).width < 360 ? AppSpacing.md : AppSpacing.lg;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.shadow.withValues(alpha: .16),
            blurRadius: 33,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        key: const ValueKey<String>('auth-glass-panel'),
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  colors.surface.withValues(alpha: .5),
                  colors.surface.withValues(alpha: .3),
                ],
              ),
              borderRadius: borderRadius,
              border: Border.all(
                color: colors.onPrimary.withValues(alpha: .62),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppSpacing.lg,
              ),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: colors.onSurface),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
