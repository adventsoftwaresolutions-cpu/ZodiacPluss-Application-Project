import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';

class SessionActionBar extends StatelessWidget {
  const SessionActionBar({
    required this.isBlocked,
    required this.onBlockTap,
    super.key,
  });

  final bool isBlocked;
  final VoidCallback onBlockTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: .96),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: _ActionButton(
              icon: Icons.sticky_note_2_outlined,
              label: 'Note',
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: _ActionButton(
              icon: Icons.outlined_flag_rounded,
              label: 'Flag risk',
              color: AppColors.error,
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: _ActionButton(
              icon: Icons.report_gmailerrorred_outlined,
              label: 'Report',
              color: AppColors.error,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ActionButton(
              icon: isBlocked ? Icons.block_rounded : Icons.person_off_outlined,
              label: isBlocked ? 'Blocked' : 'Block',
              color: AppColors.error,
              onTap: isBlocked ? null : onBlockTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .11),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, color: color, size: 21),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
