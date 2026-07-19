import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import 'splash_visual_tuning.dart';

class SplashStarField extends StatelessWidget {
  const SplashStarField({required this.animation, super.key});

  final Animation<double> animation;

  static const List<_StarSpec> _stars = <_StarSpec>[
    _StarSpec(Alignment(-.82, -.74), 15, .1, .7),
    _StarSpec(Alignment(-.56, -.58), 36, .5, 1.2),
    _StarSpec(Alignment(.78, -.18), 15, .9, .8),
    _StarSpec(Alignment(.72, .12), 12, 1.4, .7),
    _StarSpec(Alignment(-.74, .56), 22, 1.8, 1.3),
    _StarSpec(Alignment(-.82, .78), 15, 2.3, .8),
  ];

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: _stars
            .map((_StarSpec star) => _AnimatedStar(
                  animation: animation,
                  star: star,
                ))
            .toList(),
      );
}

class _AnimatedStar extends StatelessWidget {
  const _AnimatedStar({required this.animation, required this.star});

  final Animation<double> animation;
  final _StarSpec star;

  @override
  Widget build(BuildContext context) => Align(
        alignment: star.alignment,
        child: AnimatedBuilder(
          animation: animation,
          child: RepaintBoundary(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: star.blur * SplashVisualTuning.starBlurMultiplier,
                sigmaY: star.blur * SplashVisualTuning.starBlurMultiplier,
              ),
              child: Icon(
                Icons.star_rounded,
                size: star.size,
                color: AppColors.primary,
              ),
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            final double wave = math.sin(
              (animation.value * math.pi * 2) + star.phase,
            );
            return Transform.translate(
              offset: Offset(wave * 5, -wave * 7),
              child: Opacity(
                opacity: .2 + ((wave + 1) * .07),
                child: child,
              ),
            );
          },
        ),
      );
}

class _StarSpec {
  const _StarSpec(this.alignment, this.size, this.phase, this.blur);

  final Alignment alignment;
  final double size;
  final double phase;
  final double blur;
}
