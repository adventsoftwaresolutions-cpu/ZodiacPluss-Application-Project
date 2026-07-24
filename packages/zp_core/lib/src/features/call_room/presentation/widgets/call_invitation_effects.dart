import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Default accent colors for the revolving call border gradient.
///
/// These match the original `AppColors.callGlow*` values from zp_expert so the
/// visual output is identical without depending on expert-only theme tokens.
const Color _kDefaultGlowBlue = Color(0xFF4DA8FF);
const Color _kDefaultGlowViolet = Color(0xFF8B5CF6);
const Color _kDefaultGlowRose = Color(0xFFF05D8A);

/// An animated revolving gradient border painted around its [child].
///
/// Used to draw attention to incoming call cards and prompts.
class RevolvingCallBorder extends StatefulWidget {
  const RevolvingCallBorder({
    required this.child,
    this.borderRadius = 20,
    this.glowColors,
    super.key,
  });

  final Widget child;
  final double borderRadius;

  /// Optional override for the three accent colors used in the sweep gradient.
  /// Defaults to `[blue, violet, rose]` matching the original zp_expert theme.
  final List<Color>? glowColors;

  @override
  State<RevolvingCallBorder> createState() => _RevolvingCallBorderState();
}

class _RevolvingCallBorderState extends State<RevolvingCallBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color glowBlue =
        widget.glowColors != null && widget.glowColors!.isNotEmpty
            ? widget.glowColors![0]
            : _kDefaultGlowBlue;
    final Color glowViolet =
        widget.glowColors != null && widget.glowColors!.length > 1
            ? widget.glowColors![1]
            : _kDefaultGlowViolet;
    final Color glowRose =
        widget.glowColors != null && widget.glowColors!.length > 2
            ? widget.glowColors![2]
            : _kDefaultGlowRose;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) => CustomPaint(
          painter: _RevolvingBorderPainter(
            rotation: _controller.value * math.pi * 2,
            radius: widget.borderRadius + 5,
            colors: <Color>[
              Theme.of(context).colorScheme.primary,
              glowBlue,
              glowViolet,
              glowRose,
              Theme.of(context).colorScheme.primary,
            ],
          ),
          child: child,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: widget.child,
        ),
      ),
    );
  }
}

class _RevolvingBorderPainter extends CustomPainter {
  const _RevolvingBorderPainter({
    required this.rotation,
    required this.radius,
    required this.colors,
  });

  final double rotation;
  final double radius;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect bounds = Offset.zero & size;
    final Rect strokeBounds = bounds.deflate(5);
    final RRect card = RRect.fromRectAndRadius(
      strokeBounds,
      Radius.circular(radius),
    );
    final Shader shader = SweepGradient(
      colors: colors,
      transform: GradientRotation(rotation),
    ).createShader(bounds);
    canvas.drawRRect(
      card,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..shader = shader
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    canvas.drawRRect(
      card,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant _RevolvingBorderPainter oldDelegate) =>
      oldDelegate.rotation != rotation ||
      oldDelegate.radius != radius ||
      oldDelegate.colors != colors;
}

/// An attention-grabbing join button with a pulsing glow effect.
class AttentionJoinButton extends StatefulWidget {
  const AttentionJoinButton({
    required this.label,
    required this.onPressed,
    this.icon = Icons.login_rounded,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  State<AttentionJoinButton> createState() => _AttentionJoinButtonState();
}

class _AttentionJoinButtonState extends State<AttentionJoinButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1150),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final double wave =
              (math.sin(_controller.value * math.pi * 2) + 1) / 2;
          return Transform.scale(
            scale: 1 + wave * .025,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: .2 + wave * .22),
                    blurRadius: 9 + wave * 8,
                    spreadRadius: wave * 1.5,
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: FilledButton.icon(
          onPressed: widget.onPressed,
          icon: Icon(widget.icon, size: 17),
          label: Text(widget.label),
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      );
}
