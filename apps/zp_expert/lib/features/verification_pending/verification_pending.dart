import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import 'widgets/verification_pending_card.dart';

class VerificationPendingPage extends StatelessWidget {
  const VerificationPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientPage(
      child: SafeArea(
        child: Center(
          child: VerificationPendingCard(),
        ),
      ),
    );
  }
}