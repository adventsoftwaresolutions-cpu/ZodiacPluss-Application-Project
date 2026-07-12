import 'dart:ui';
import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_radius.dart';
import '../../themes/app_spacing.dart';
import 'nav_item.dart';

class AnimatedNavbar extends StatelessWidget {
  const AnimatedNavbar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double _barHeight = 64;
  static const double _indicatorWidth = 24;
  static const double _indicatorHeight = 3;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color activeColor =
        isDark ? AppColors.primaryVariant : AppColors.primary;
    const Color inactiveColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md, 0, AppSpacing.md, AppSpacing.md,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: _barHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
              ),
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double itemWidth = constraints.maxWidth / items.length;
                return Stack(
                  children: <Widget>[
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      left: itemWidth * currentIndex +
                          (itemWidth - _indicatorWidth) / 2,
                      top: 6,
                      child: Container(
                        width: _indicatorWidth,
                        height: _indicatorHeight,
                        decoration: BoxDecoration(
                          color: activeColor,
                          borderRadius:
                              BorderRadius.circular(_indicatorHeight / 2),
                        ),
                      ),
                    ),
                    Row(
                      children: List<Widget>.generate(items.length, (int i) {
                        final bool selected = i == currentIndex;
                        final NavItem item = items[i];
                        return Expanded(
                          child: InkWell(
                            onTap: () => onTap(i),
                            child: Center(
                              child: Icon(
                                selected ? item.selectedIcon : item.icon,
                                color: selected ? activeColor : inactiveColor,
                                size: 24,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}