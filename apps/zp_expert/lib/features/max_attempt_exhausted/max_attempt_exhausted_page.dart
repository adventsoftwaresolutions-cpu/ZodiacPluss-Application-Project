import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import 'widgets/max_attempt_exhausted_card.dart';

class MaxAttemptExhaustedPage extends StatelessWidget {
  const MaxAttemptExhaustedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientPage(
      child: SafeArea(
        child: Center(
          child: MaxAttemptExhaustedCard(),
        ),
      ),
    );
  }
}