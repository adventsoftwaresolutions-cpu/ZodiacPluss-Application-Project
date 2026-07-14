import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import '../data/ticket_model.dart';

class TicketStatusFilters extends StatelessWidget {
  const TicketStatusFilters({
    required this.selectedFilter,
    required this.onSelected,
    super.key,
  });

  final TicketProgress selectedFilter;
  final ValueChanged<TicketProgress> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: TicketProgress.values
              .map(
                (TicketProgress filter) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _FilterChip(
                    filter: filter,
                    isSelected: filter == selectedFilter,
                    onTap: () => onSelected(filter),
                  ),
                ),
              )
              .toList(),
        ),
      );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  final TicketProgress filter;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _icon => switch (filter) {
        TicketProgress.all => Icons.layers_outlined,
        TicketProgress.inProgress => Icons.access_time_rounded,
        TicketProgress.resolved => Icons.check_circle_outline_rounded,
        TicketProgress.closed => Icons.cancel_outlined,
      };

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.white.withValues(alpha: .85),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(_icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 7),
                Text(
                  filter.label,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
