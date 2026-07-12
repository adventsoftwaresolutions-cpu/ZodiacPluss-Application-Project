import 'package:flutter/material.dart';

class GradientPage extends StatelessWidget {
  const GradientPage({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.primary,
              colors.secondary,
            ],
            stops: const [0.0, 0.28],
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}