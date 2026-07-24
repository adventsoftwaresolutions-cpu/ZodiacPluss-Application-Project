import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/kundali_chart_model.dart';

class KundaliChartReveal extends StatefulWidget {
  const KundaliChartReveal({
    required this.svg,
    required this.style,
    required this.semanticsLabel,
    super.key,
  });

  final String svg;
  final KundaliChartStyle style;
  final String semanticsLabel;

  @override
  State<KundaliChartReveal> createState() => _KundaliChartRevealState();
}

class _KundaliChartRevealState extends State<KundaliChartReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant KundaliChartReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.svg != widget.svg || oldWidget.style != widget.style) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final chart = SvgPicture.string(widget.svg, fit: BoxFit.contain);
    const logo = _KundaliLogoBackdrop();

    if (MediaQuery.disableAnimationsOf(context)) {
      return Semantics(
        image: true,
        label: widget.semanticsLabel,
        child: Stack(
          fit: StackFit.expand,
          children: [ColoredBox(color: colors.surface), logo, chart],
        ),
      );
    }

    return Semantics(
      image: true,
      label: widget.semanticsLabel,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, child) {
          final value = _progress.value;
          final svgOpacity = const Interval(
            0.42,
            1,
            curve: Curves.easeOut,
          ).transform(value);
          final drawingOpacity = 1 - const Interval(0.78, 1).transform(value);

          return Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: colors.surface),
              logo,
              Opacity(opacity: svgOpacity, child: child),
              IgnorePointer(
                child: Opacity(
                  opacity: drawingOpacity,
                  child: CustomPaint(
                    painter: _KundaliLinePainter(
                      style: widget.style,
                      progress: value,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: chart,
      ),
    );
  }
}

class _KundaliLogoBackdrop extends StatelessWidget {
  const _KundaliLogoBackdrop();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Opacity(
          opacity: 0.045,
          child: FractionallySizedBox(
            widthFactor: 0.58,
            heightFactor: 0.58,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _KundaliLinePainter extends CustomPainter {
  const _KundaliLinePainter({
    required this.style,
    required this.progress,
    required this.color,
  });

  final KundaliChartStyle style;
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = switch (style) {
      KundaliChartStyle.northIndian => _northIndianPath(size),
      KundaliChartStyle.southIndian => _southIndianPath(size),
      KundaliChartStyle.eastIndian => _eastIndianPath(size),
    };
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    _drawPartialPath(canvas, path, paint, progress);
  }

  Path _northIndianPath(Size size) {
    final left = size.width * 0.01;
    final top = size.height * 0.01;
    final right = size.width * 0.99;
    final bottom = size.height * 0.99;
    final center = Offset(size.width / 2, size.height / 2);
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(left, top, right, bottom),
          Radius.circular(size.width * 0.045),
        ),
      )
      ..moveTo(left, top)
      ..lineTo(right, bottom)
      ..moveTo(right, top)
      ..lineTo(left, bottom)
      ..moveTo(left, center.dy)
      ..lineTo(center.dx, top)
      ..lineTo(right, center.dy)
      ..lineTo(center.dx, bottom)
      ..close();
    return path;
  }

  Path _southIndianPath(Size size) {
    final cell = size.width / 4;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(size.width * 0.045),
        ),
      );
    for (var i = 1; i < 4; i++) {
      path
        ..moveTo(cell * i, 0)
        ..lineTo(cell * i, size.height)
        ..moveTo(0, cell * i)
        ..lineTo(size.width, cell * i);
    }
    return path;
  }

  Path _eastIndianPath(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(size.width * 0.045),
        ),
      )
      ..moveTo(center.dx, 0)
      ..lineTo(size.width, center.dy)
      ..lineTo(center.dx, size.height)
      ..lineTo(0, center.dy)
      ..close()
      ..moveTo(center.dx, 0)
      ..lineTo(center.dx, size.height)
      ..moveTo(0, center.dy)
      ..lineTo(size.width, center.dy)
      ..moveTo(size.width * 0.25, size.height * 0.25)
      ..lineTo(size.width * 0.75, size.height * 0.75)
      ..moveTo(size.width * 0.75, size.height * 0.25)
      ..lineTo(size.width * 0.25, size.height * 0.75);
  }

  void _drawPartialPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double animationProgress,
  ) {
    final metrics = path.computeMetrics().toList(growable: false);
    final totalLength = metrics.fold<double>(
      0,
      (sum, metric) => sum + metric.length,
    );
    var remaining = totalLength * animationProgress.clamp(0.0, 1.0);

    for (final metric in metrics) {
      if (remaining <= 0) break;
      final length = math.min(metric.length, remaining);
      canvas.drawPath(metric.extractPath(0, length), paint);
      remaining -= metric.length;
    }
  }

  @override
  bool shouldRepaint(covariant _KundaliLinePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.style != style ||
        oldDelegate.color != color;
  }
}
