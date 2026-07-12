import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zp_client/core/themes/app_colors.dart';
import 'nav_item.dart';
export 'nav_item.dart';

class ZPAnimatedNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<ZPNavItem> items;

  const ZPAnimatedNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  static const double _barHeight = 64;
  static const double _collapsedWidth = 64;
  static const Duration _duration = Duration(milliseconds: 320);
  static const Curve _curve = Curves.fastOutSlowIn;
  static const double _containerHPad = 8; // Container padding: 4 left + 4 right
  static const double _pillHMargin = 4;   // _NavPill margin: 2 left + 2 right

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableWidth = constraints.maxWidth;

            final double usableWidth = availableWidth -
                _containerHPad -
                (_pillHMargin * items.length);

            final double expandedWidth =
                usableWidth - (_collapsedWidth * (items.length - 1));

            return Container(
              height: _barHeight,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(_barHeight / 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(items.length, (index) {
                  final bool selected = index == currentIndex;
                  return _NavPill(
                    item: items[index],
                    selected: selected,
                    width: selected ? expandedWidth : _collapsedWidth,
                    height: _barHeight - 8,
                    duration: _duration,
                    curve: _curve,
                    onTap: () => onTap(index),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavPill extends StatelessWidget {
  final ZPNavItem item;
  final bool selected;
  final double width;
  final double height;
  final Duration duration;
  final Curve curve;
  final VoidCallback onTap;

  const _NavPill({
    required this.item,
    required this.selected,
    required this.width,
    required this.height,
    required this.duration,
    required this.curve,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        decoration: BoxDecoration(
          color: selected ? AppColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: height, // Same height and width for a perfect circle
              height: height, // Matches the yellow container's height
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.transparent : Colors.white,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                item.iconAsset,
                width: 25,
                height: 25,
                colorFilter: const ColorFilter.mode(
                  AppColors.secondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            // Wrapping in Flexible prevents any text overflow
            Flexible(
              child: AnimatedSize(
                duration: duration,
                curve: curve,
                child: selected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8, right: 16),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : const SizedBox(width: 0, height: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}