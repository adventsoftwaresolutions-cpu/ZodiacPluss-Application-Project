import 'package:flutter/material.dart';

class ContactSupportButton extends StatelessWidget {
  const ContactSupportButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          backgroundColor: colors.surfaceContainerHighest,
          foregroundColor: colors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          // TODO: Navigate to support/help page
        },
        child: const Text(
          'Contact Support',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}