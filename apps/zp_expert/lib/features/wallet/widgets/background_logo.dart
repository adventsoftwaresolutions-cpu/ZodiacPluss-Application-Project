import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zp_expert/shared/constants/app_assets.dart';

class BackgroundLogo extends StatelessWidget {
  const BackgroundLogo({
    super.key,
    this.size = 220,
    this.opacity = 0.12,
    this.blurSigma = 2.5,
  });

  final double size;
  final double opacity;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: blurSigma,
          sigmaY: blurSigma,
        ),
        child: SvgPicture.asset(
          AppAssets.logo,
          width: size,
          height: size,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}