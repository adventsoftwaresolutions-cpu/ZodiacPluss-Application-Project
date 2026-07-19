import 'package:flutter/material.dart';

class CallParticipantAvatar extends StatefulWidget {
  const CallParticipantAvatar({
    required this.name,
    this.radius = 62,
    this.animate = true,
    super.key,
  });

  final String name;
  final double radius;
  final bool animate;

  @override
  State<CallParticipantAvatar> createState() => _CallParticipantAvatarState();
}

class _CallParticipantAvatarState extends State<CallParticipantAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
      lowerBound: .96,
      upperBound: 1.04,
    );
    if (widget.animate) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant CallParticipantAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate == widget.animate) return;
    if (widget.animate) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 1;
    }
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
          final double pulse = widget.animate ? _controller.value : 1;
          return Transform.scale(
            scale: pulse,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimary
                      .withValues(alpha: .2),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: .34),
                    blurRadius: 28,
                    spreadRadius: widget.animate ? 5 : 1,
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: CircleAvatar(
          radius: widget.radius,
          backgroundColor:
              Theme.of(context).colorScheme.surface.withValues(alpha: .18),
          child: Text(
            _initials(widget.name),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: widget.radius * .42,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );

  String _initials(String value) {
    final List<String> words = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((String word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}
