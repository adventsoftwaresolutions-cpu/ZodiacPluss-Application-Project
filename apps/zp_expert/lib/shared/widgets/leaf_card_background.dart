import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';

/// A responsive decorative leaf intended for the bottom-right of a card Stack.
class LeafCardBackground extends StatelessWidget {
  const LeafCardBackground({
    super.key,
    this.color,
    this.opacity = .1,
    this.blurSigma = 0,
    this.widthFactor = .3,
    this.minWidth = 72,
    this.maxWidth = 124,
  });

  final Color? color;
  final double opacity;
  final double blurSigma;
  final double widthFactor;
  final double minWidth;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : maxWidth / widthFactor;
            final double width =
                (availableWidth * widthFactor).clamp(minWidth, maxWidth);
            final Widget leaf = SvgPicture.asset(
              AppAssets.leaf,
              width: width,
              fit: BoxFit.contain,
              colorFilter: color == null
                  ? null
                  : ColorFilter.mode(color!, BlendMode.srcIn),
            );

            return Align(
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: opacity,
                child: ImageFiltered(
                  enabled: blurSigma > 0,
                  imageFilter: ImageFilter.blur(
                    sigmaX: blurSigma,
                    sigmaY: blurSigma,
                  ),
                  child: leaf,
                ),
              ),
            );
          },
        ),
      );
}
