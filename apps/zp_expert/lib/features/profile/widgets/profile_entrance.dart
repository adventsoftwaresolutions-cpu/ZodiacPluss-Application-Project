import 'package:flutter/material.dart';

class ProfileEntrance extends StatelessWidget {
  const ProfileEntrance({required this.index, required this.child, super.key});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 320 + (index * 55)),
        curve: Curves.easeOutCubic,
        tween: Tween<double>(begin: 0, end: 1),
        child: child,
        builder: (BuildContext context, double value, Widget? child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        ),
      );
}
