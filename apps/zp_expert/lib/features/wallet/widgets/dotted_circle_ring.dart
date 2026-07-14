import 'dart:math' as math;
import 'package:flutter/material.dart';

class DottedCircleRing extends StatelessWidget {
  const DottedCircleRing({
    required this.diameter,
    required this.color,
    this.dotCount = 24,
    this.dotRadius = 1.5,
    super.key,
  });

  final double diameter;
  final Color color;
  final int dotCount;
  final double dotRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(diameter, diameter),
      painter: _DottedRingPainter(
        color: color,
        dotCount: dotCount,
        dotRadius: dotRadius,
      ),
    );
  }
}

class _DottedRingPainter extends CustomPainter {
  _DottedRingPainter({
    required this.color,
    required this.dotCount,
    required this.dotRadius,
  });

  final Color color;
  final int dotCount;
  final double dotRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    for (int i = 0; i < dotCount; i++) {
      final double angle = (2 * math.pi / dotCount) * i;
      final Offset dotCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawCircle(dotCenter, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(_DottedRingPainter oldDelegate) => false;
}