import 'package:flutter/material.dart';

import '../../../themes/app_radius.dart';

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({required this.child, super.key, this.tint});

  final Widget child;
  final Color? tint;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tint ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 16,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: child,
      );
}

class ProfileSectionTitle extends StatelessWidget {
  const ProfileSectionTitle({
    required this.icon,
    required this.title,
    super.key,
    this.action,
  });

  final IconData icon;
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 25),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF15183E),
                  ),
            ),
          ),
          if (action case final Widget action) action,
        ],
      );
}

class ProfileEditButton extends StatelessWidget {
  const ProfileEditButton({
    required this.isEditing,
    required this.onPressed,
    super.key,
  });

  final bool isEditing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: FilledButton.icon(
          key: ValueKey<bool>(isEditing),
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          ),
          icon: Icon(isEditing ? Icons.check_rounded : Icons.edit_outlined,
              size: 15),
          label: Text(isEditing ? 'Save' : 'Edit'),
        ),
      );
}
