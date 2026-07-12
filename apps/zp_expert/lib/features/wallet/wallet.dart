import 'package:flutter/material.dart';
import '../../shared/widgets/gradient_page.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientPage(
      child: Center(
        child: Text('Wallet'),
      ),
    );
  }
}