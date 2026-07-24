import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/constants/app_assets.dart';
import '../../../themes/app_colors.dart';

class BloomingLotus extends StatelessWidget {
  const BloomingLotus({required this.animation, super.key});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _LotusGlow(animation: animation),
          _LotusArtwork(animation: animation),
        ],
      );
}

class _LotusGlow extends StatelessWidget {
  const _LotusGlow({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: animation,
        child: RepaintBoundary(
          child: Container(
            width: 310,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  AppColors.callGlowRose.withValues(alpha: .58),
                  AppColors.callGlowRose.withValues(alpha: 0),
                ],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.callGlowRose.withValues(alpha: .48),
                  blurRadius: 56,
                  spreadRadius: 18,
                ),
              ],
            ),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          final double progress =
              Curves.easeOutCubic.transform(animation.value);
          final double glowPulse =
              .72 + math.sin(animation.value * math.pi * 5).abs() * .28;

          return Opacity(
            opacity: progress * .96 * glowPulse,
            child: child,
          );
        },
      );
}

class _LotusArtwork extends StatelessWidget {
  const _LotusArtwork({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: animation,
        child: RepaintBoundary(
          child: SvgPicture.asset(
            AppAssets.splashLotus,
            key: const ValueKey<String>('splash-lotus'),
            width: 350,
            fit: BoxFit.contain,
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          final double progress =
              Curves.easeOutCubic.transform(animation.value);
          return Transform.translate(
            offset: Offset(0, 72 * (1 - progress)),
            child: Transform.scale(
              key: const ValueKey<String>('lotus-bloom-transform'),
              alignment: Alignment.bottomCenter,
              scale: .18 + (.82 * progress),
              child: child,
            ),
          );
        },
      );
}
