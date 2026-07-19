import 'dart:ui';

import 'package:flutter/material.dart';

import '../../themes/app_radius.dart';
import '../../themes/app_spacing.dart';

class SidebarTriggerButton extends StatelessWidget {
  const SidebarTriggerButton({
    super.key,
    this.onTap,
    this.diameter = 40,
    this.iconSize = 22,
  });

  final VoidCallback? onTap;
  final double diameter;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: 'Open sidebar',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Material(
            color: colors.surface.withValues(alpha: isDark ? 0.72 : 0.82),
            child: InkWell(
              onTap: onTap ?? () {},
              child: Container(
                width: diameter,
                height: diameter,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: (isDark ? Colors.white : colors.primary)
                        .withValues(alpha: 0.16),
                  ),
                ),
                child: Icon(
                  Icons.menu_open_rounded,
                  size: iconSize,
                  color: colors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
