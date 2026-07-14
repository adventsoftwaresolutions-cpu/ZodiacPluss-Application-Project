import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../shared/constants/app_assets.dart';

class WalletAnimation extends StatelessWidget {
  const WalletAnimation({
    super.key,
    this.width = 200,
    this.height = 200,
    this.fit = BoxFit.contain,
    this.loop = true,
    this.autoplay = true,
  });

  final double width;
  final double height;
  final BoxFit fit;
  final bool loop;
  final bool autoplay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Lottie.asset(
        AppAssets.walletAnimation,
        width: width,
        height: height,
        fit: fit,
        repeat: false,
        animate: autoplay,
      ),
    );
  }
}