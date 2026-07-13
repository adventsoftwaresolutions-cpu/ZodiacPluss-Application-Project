import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import 'widgets/verification_complete_card.dart';

class VerificationCompletePage extends StatelessWidget {
  const VerificationCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientPage(
      child: SafeArea(
        child: Center(
          child: VerificationCompleteCard(),
        ),
      ),
    );
  }
}