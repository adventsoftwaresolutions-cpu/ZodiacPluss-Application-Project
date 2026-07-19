import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/constants/app_assets.dart';
import '../../../themes/app_colors.dart';

class AuthBlobBackground extends StatefulWidget {
  const AuthBlobBackground({super.key});

  @override
  State<AuthBlobBackground> createState() => _AuthBlobBackgroundState();
}

class _AuthBlobBackgroundState extends State<AuthBlobBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: IgnorePointer(
          child: RepaintBoundary(
            child: ClipRect(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double width = constraints.maxWidth;
                  const double blurVal = 41, blurPulse = 4;
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) => Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        _DriftingBlob(
                          asset: AppAssets.blobOne,
                          tint: AppColors.callGlowRose,
                          alignment: const Alignment(1.18, -.78),
                          size: (width * .88).clamp(230, 390).toDouble(),
                          travel: const Offset(34, 44),
                          progress: _controller.value,
                          phase: 0,
                          blur: blurVal,
                          blurPulse: blurPulse,
                          opacity: .46,
                          rotationDirection: 1,
                        ),
                        _DriftingBlob(
                          asset: AppAssets.blob,
                          tint: AppColors.primary,
                          alignment: const Alignment(-1.22, .16),
                          size: (width * .92).clamp(240, 410).toDouble(),
                          travel: const Offset(42, 30),
                          progress: _controller.value,
                          phase: .36,
                          blur: blurVal,
                          blurPulse: blurPulse,
                          opacity: .4,
                          rotationDirection: -1,
                        ),
                        _DriftingBlob(
                          asset: AppAssets.blobOne,
                          tint: AppColors.callGlowViolet,
                          alignment: const Alignment(.82, 1.12),
                          size: (width * .72).clamp(190, 330).toDouble(),
                          travel: const Offset(30, 38),
                          progress: _controller.value,
                          phase: .68,
                          blur: blurVal,
                          blurPulse: blurPulse,
                          opacity: .36,
                          rotationDirection: -1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
}

class _DriftingBlob extends StatelessWidget {
  const _DriftingBlob({
    required this.asset,
    required this.tint,
    required this.alignment,
    required this.size,
    required this.travel,
    required this.progress,
    required this.phase,
    required this.blur,
    required this.blurPulse,
    required this.opacity,
    required this.rotationDirection,
  });

  final String asset;
  final Color tint;
  final Alignment alignment;
  final double size;
  final Offset travel;
  final double progress;
  final double phase;
  final double blur;
  final double blurPulse;
  final double opacity;
  final double rotationDirection;

  @override
  Widget build(BuildContext context) {
    final double radians = (progress + phase) * math.pi * 2;
    final Offset offset = Offset(
      math.sin(radians) * travel.dx,
      math.cos(radians * 1.08) * travel.dy,
    );
    final double sigma = blur + math.sin(radians + math.pi / 3) * blurPulse;
    final double rotation = progress * math.pi * 2 * rotationDirection;

    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: rotation,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: Opacity(
              opacity: opacity,
              child: SizedBox.square(
                dimension: size,
                child: SvgPicture.asset(
                  asset,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
