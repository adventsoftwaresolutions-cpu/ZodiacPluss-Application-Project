import 'package:flutter/material.dart';

class HelpText extends StatelessWidget {
  const HelpText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "By continuing, you agree to our Terms & Conditions and Privacy Policy.",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.black54,
            height: 1.5,
          ),
    );
  }
}