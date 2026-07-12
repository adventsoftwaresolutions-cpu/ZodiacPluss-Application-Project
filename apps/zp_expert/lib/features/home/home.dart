import 'package:flutter/material.dart';
import '../../shared/widgets/gradient_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientPage(
      child: Center(
        child: Text('Home'),
      ),
    );
  }
}