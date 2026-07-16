import 'package:flutter/material.dart';

class TopScrollFade extends StatelessWidget {
  const TopScrollFade({
    required this.fadeExtent,
    required this.child,
    super.key,
  });

  final double fadeExtent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (fadeExtent <= 0) return child;

    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (Rect bounds) {
        final double fadeStop =
            (fadeExtent / bounds.height).clamp(0.0, 1.0);

        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const <Color>[
            Colors.transparent,
            Colors.black,
            Colors.black,
          ],
          stops: <double>[0, fadeStop, 1],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
