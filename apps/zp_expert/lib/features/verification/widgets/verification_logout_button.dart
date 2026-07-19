import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/app_routes.dart';

class VerificationLogoutButton extends StatelessWidget {
  const VerificationLogoutButton({super.key});

  @override
  Widget build(BuildContext context) => TextButton.icon(
        key: const ValueKey<String>('verification-logout-button'),
        onPressed: () => context.go(ExpertRoutes.auth),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text('Log out'),
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
          minimumSize: const Size(0, 44),
        ),
      );
}
