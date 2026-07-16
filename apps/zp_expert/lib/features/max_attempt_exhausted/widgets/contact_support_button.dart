import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/app_routes.dart';

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
        onPressed: () => context.push(ExpertRoutes.raiseTicket),
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
