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
    final Color inactiveColor =
        (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.55);

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
              // subtle translucent gradient to give depth
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Theme.of(context).colorScheme.surface.withOpacity(0.46),
                  Theme.of(context).colorScheme.surface.withOpacity(0.32),
                ],
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
              ),
              // slight outer shadow for lift
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                // a tiny negative spread shadow to fake inner depth (lightweight)
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Stack(
              children: <Widget>[
                // main interactive area
                LayoutBuilder(
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
                                shadows: selected
                                    ? null
                                    : const <Shadow>[
                                        Shadow(
                                          color: Colors.black38,
                                          blurRadius: 4,
                                        ),
                                      ],
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
                // subtle top sheen for glassy highlight
                Positioned(
                  left: 0,
                  right: 0,
                  top: 6,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      height: 18,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white.withOpacity(isDark ? 0.03 : 0.18),
                            Colors.white.withOpacity(isDark ? 0.01 : 0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}