import 'package:flutter/material.dart';
import '../../shared/widgets/gradient_page.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientPage(
      child: Center(
        child: Text('Session'),
      ),
    );
  }
}