import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../shared/constants/app_assets.dart';
import 'wallet_balance_card.dart';

class AvailabilityStatusVisual extends StatelessWidget {
  const AvailabilityStatusVisual({
    required this.isOnline,
    required this.onCheckWalletStatus,
    super.key,
  });

  final bool isOnline;
  final VoidCallback onCheckWalletStatus;

  @override
  Widget build(BuildContext context) {
    final ValueKey<bool> currentKey = ValueKey<bool>(isOnline);
    return ClipRect(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeInOutCubic,
        height: isOnline ? 120 : 56,
        width: double.infinity,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 520),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: (
            Widget? currentChild,
            List<Widget> previousChildren,
          ) {
            return Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: <Widget>[
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
          ) {
            final bool isIncoming = child.key == currentKey;
            final Animation<Offset> position = Tween<Offset>(
              begin: isIncoming ? const Offset(1, 0) : const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation);
            return SlideTransition(
              position: position,
              child: Align(child: child),
            );
          },
          child: isOnline
              ? const SizedBox.expand(
                  key: ValueKey<bool>(true),
                  child: ClipRRect(
                    key: ValueKey<String>('yoga-wrapper-background'),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: ColoredBox(
                      key: ValueKey<String>('yoga-wrapper-background-color'),
                      color: Color(0xFFFFFFE8),
                      child: Align(child: _YogaAnimation()),
                    ),
                  ),
                )
              : WalletBalanceCard(
                  key: const ValueKey<bool>(false),
                  onCheckStatus: onCheckWalletStatus,
                ),
        ),
      ),
    );
  }
}

class _YogaAnimation extends StatefulWidget {
  const _YogaAnimation();

  @override
  State<_YogaAnimation> createState() => _YogaAnimationState();
}

class _YogaAnimationState extends State<_YogaAnimation>
    with SingleTickerProviderStateMixin {
  static const double _stateMachineSpeed = .75;

  late final AnimationController _controller;
  Timer? _introTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  void _start(LottieComposition composition) {
    _introTimer?.cancel();
    _controller.stop();
    _controller.duration = composition.duration;
    final Marker? intro = composition.getMarker('InAnimation');
    final Marker? loop = composition.getMarker('MidAnimation');

    if (intro == null || loop == null) {
      _controller.repeat();
      return;
    }

    final Duration introDuration = _markerDuration(
      intro,
      composition.frameRate,
      speed: _stateMachineSpeed,
    );
    _controller.value = _boundedProgress(intro.start);
    _controller.animateTo(
      _boundedProgress(intro.end),
      duration: introDuration,
      curve: Curves.linear,
    );
    _introTimer = Timer(introDuration, () {
      if (!mounted) return;
      _controller.stop();
      final double loopStart = _boundedProgress(loop.start);
      final double loopEnd = _boundedProgress(loop.end);
      _controller.value = loopStart;
      _controller.repeat(
        min: loopStart,
        max: loopEnd,
        period: _markerDuration(loop, composition.frameRate),
      );
    });
  }

  double _boundedProgress(double progress) => progress.clamp(0, 1).toDouble();

  Duration _markerDuration(
    Marker marker,
    double frameRate, {
    double speed = 1,
  }) {
    final double seconds = marker.durationFrames / frameRate / speed;
    return Duration(milliseconds: (seconds * 1000).round());
  }

  @override
  void dispose() {
    _introTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      AppAssets.yogaAnimation,
      key: const ValueKey<String>('yoga-lottie-animation'),
      controller: _controller,
      animate: false,
      repeat: false,
      fit: BoxFit.contain,
      onLoaded: _start,
    );
  }
}
