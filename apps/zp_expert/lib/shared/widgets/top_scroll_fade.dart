import 'package:flutter/material.dart';

import '../../themes/app_spacing.dart';

class TopScrollFade extends StatefulWidget {
  const TopScrollFade({
    required this.child,
    this.fadeExtent = AppSpacing.xl,
    super.key,
  });

  final Widget child;
  final double fadeExtent;

  @override
  State<TopScrollFade> createState() => _TopScrollFadeState();
}

class _TopScrollFadeState extends State<TopScrollFade> {
  bool _isScrolled = false;

  bool _handleScroll(ScrollNotification notification) {
    if (notification.depth != 0 || notification.metrics.axis != Axis.vertical) {
      return false;
    }

    final bool isScrolled = notification.metrics.extentBefore > 0.5;
    if (isScrolled != _isScrolled) {
      setState(() => _isScrolled = isScrolled);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScroll,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        tween: Tween<double>(begin: 0, end: _isScrolled ? 1 : 0),
        builder: (BuildContext context, double fade, Widget? child) {
          return ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (Rect bounds) {
              final double fadeStop = bounds.height <= 0
                  ? 1
                  : (widget.fadeExtent / bounds.height).clamp(0.0, 1.0);

              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withValues(alpha: 1 - fade),
                  Colors.black,
                  Colors.black,
                ],
                stops: <double>[0, fadeStop, 1],
              ).createShader(bounds);
            },
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
