import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import 'widgets/verification_failed_card.dart';

class VerificationFailedPage extends StatelessWidget {
  const VerificationFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientPage(
      child: SafeArea(
        child: Center(
          child: VerificationFailedCard(),
        ),
      ),
    );
  }
}