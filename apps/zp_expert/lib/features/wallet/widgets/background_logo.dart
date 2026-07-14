import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zp_expert/shared/constants/app_assets.dart';

/// Faint zodiac-wheel watermark rendered behind the balance card's text.
/// Purely decorative — no interaction, no state.
class BackgroundLogo extends StatelessWidget {
  const BackgroundLogo({
    this.size = 220,
    this.opacity = 0.15,
    super.key,
  });

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: SvgPicture.asset(
        AppAssets.logo,
        width: size,
        height: size,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}