import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import 'widgets/verification_body.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientPage(
      child: SafeArea(
        child: VerificationBody(),
      ),
    );
  }
}
