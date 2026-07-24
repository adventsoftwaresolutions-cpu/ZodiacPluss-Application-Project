import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../shared/constants/app_assets.dart';
import '../../../themes/app_colors.dart';
import 'blooming_lotus.dart';
import 'splash_star_field.dart';
import 'splash_visual_tuning.dart';

class SplashScene extends StatefulWidget {
  const SplashScene({required this.onCompleted, super.key});

  final VoidCallback onCompleted;

  @override
  State<SplashScene> createState() => _SplashSceneState();
}

class _SplashSceneState extends State<SplashScene>
    with SingleTickerProviderStateMixin {
  // Adjust this value to control how long the splash stays on screen.
  static const Duration _duration = Duration(milliseconds: 1650);

  late final AnimationController _controller;
  late final Animation<double> _logoEntrance;
  late final Animation<double> _nameEntrance;
  late final Animation<double> _moonEntrance;
  late final Animation<double> _lotusBloom;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration)
      ..addStatusListener(_handleStatus)
      ..forward();
    _logoEntrance = _interval(0, .34, Curves.easeOutBack);
    _nameEntrance = _interval(0, .4, Curves.easeOutCubic);
    _moonEntrance = _interval(0, .46, Curves.easeOutCubic);
    _lotusBloom = _interval(0, .62, Curves.easeOutCubic);
  }

  Animation<double> _interval(double begin, double end, Curve curve) =>
      CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, end, curve: curve),
      );

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) widget.onCompleted();
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_handleStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.secondaryVariant,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.secondaryVariant,
                AppColors.white,
                AppColors.secondary,
              ],
              stops: <double>[0, .68, 1],
            ),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                _SplashLayout(
              size: constraints.biggest,
              controller: _controller,
              logoEntrance: _logoEntrance,
              nameEntrance: _nameEntrance,
              moonEntrance: _moonEntrance,
              lotusBloom: _lotusBloom,
            ),
          ),
        ),
      );
}

class _SplashLayout extends StatelessWidget {
  const _SplashLayout({
    required this.size,
    required this.controller,
    required this.logoEntrance,
    required this.nameEntrance,
    required this.moonEntrance,
    required this.lotusBloom,
  });

  final Size size;
  final Animation<double> controller;
  final Animation<double> logoEntrance;
  final Animation<double> nameEntrance;
  final Animation<double> moonEntrance;
  final Animation<double> lotusBloom;

  @override
  Widget build(BuildContext context) {
    final double logoSize = (size.width * .48).clamp(150, 205).toDouble();
    final double originalLotusWidth =
        (size.width * .92).clamp(300, 410).toDouble();
    final double lotusWidth =
        originalLotusWidth * SplashVisualTuning.lotusSizeFactor;

    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SplashStarField(animation: controller),
          Positioned(
            top: size.height * .23,
            left: 20,
            right: 20,
            child: _BrandSequence(
              logoSize: logoSize,
              logoEntrance: logoEntrance,
              nameEntrance: nameEntrance,
              moonEntrance: moonEntrance,
            ),
          ),
          Positioned(
            left: (size.width - lotusWidth) / 2,
            bottom: SplashVisualTuning.lotusBottomInset,
            width: lotusWidth,
            child: BloomingLotus(animation: lotusBloom),
          ),
        ],
      ),
    );
  }
}

class _BrandSequence extends StatelessWidget {
  const _BrandSequence({
    required this.logoSize,
    required this.logoEntrance,
    required this.nameEntrance,
    required this.moonEntrance,
  });

  final double logoSize;
  final Animation<double> logoEntrance;
  final Animation<double> nameEntrance;
  final Animation<double> moonEntrance;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FadeTransition(
            opacity: logoEntrance,
            child: ScaleTransition(
              scale: logoEntrance,
              child: SizedBox.square(
                dimension: logoSize,
                child: Lottie.asset(
                  AppAssets.splashLogoAnimation,
                  key: const ValueKey<String>('splash-logo-animation'),
                  repeat: false,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _FadeSlide(
            animation: nameEntrance,
            offset: const Offset(0, .28),
            child: SvgPicture.asset(
              AppAssets.logoName,
              key: const ValueKey<String>('splash-brand-name'),
              width: (logoSize * .96).clamp(155, 195).toDouble(),
            ),
          ),
          const SizedBox(height: 26),
          _FadeSlide(
            animation: moonEntrance,
            offset: const Offset(0, .4),
            child: ImageFiltered(
              key: const ValueKey<String>('splash-moon-blur'),
              imageFilter: ImageFilter.blur(
                sigmaX: SplashVisualTuning.moonPhaseBlurSigma,
                sigmaY: SplashVisualTuning.moonPhaseBlurSigma,
              ),
              child: Opacity(
                opacity: .68,
                child: SvgPicture.asset(
                  AppAssets.splashMoonPhase,
                  key: const ValueKey<String>('splash-moon-phase'),
                  width: (logoSize * .8).clamp(130, 165).toDouble(),
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryVariant,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}

class _FadeSlide extends StatelessWidget {
  const _FadeSlide({
    required this.animation,
    required this.offset,
    required this.child,
  });

  final Animation<double> animation;
  final Offset offset;
  final Widget child;

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(begin: offset, end: Offset.zero).animate(
            animation,
          ),
          child: child,
        ),
      );
}
