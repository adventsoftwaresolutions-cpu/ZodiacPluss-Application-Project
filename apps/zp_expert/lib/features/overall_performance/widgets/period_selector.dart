import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import '../../../themes/app_spacing.dart';

enum PeriodMode { daily, monthly }

class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    required this.mode,
    required this.selectedPeriodKey,
    required this.onModeChanged,
    required this.onPeriodSelected,
    super.key,
  });

  final PeriodMode mode;
  final String? selectedPeriodKey;
  final ValueChanged<PeriodMode> onModeChanged;
  final ValueChanged<String?> onPeriodSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl - 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Select Period',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D3B3E),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _ModeToggle(mode: mode, onModeChanged: onModeChanged),
          const SizedBox(height: AppSpacing.md),
          _ChipRow(
            mode: mode,
            selectedPeriodKey: selectedPeriodKey,
            onPeriodSelected: onPeriodSelected,
          ),
        ],
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({
    required this.mode,
    required this.onModeChanged,
  });

  final PeriodMode mode;
  final ValueChanged<PeriodMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F5),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: <Widget>[
          _ToggleTab(
            label: 'Daily',
            isSelected: mode == PeriodMode.daily,
            onTap: () => onModeChanged(PeriodMode.daily),
          ),
          _ToggleTab(
            label: 'Monthly',
            isSelected: mode == PeriodMode.monthly,
            onTap: () => onModeChanged(PeriodMode.monthly),
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  const _ToggleTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF526565),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({
    required this.mode,
    required this.selectedPeriodKey,
    required this.onPeriodSelected,
  });

  final PeriodMode mode;
  final String? selectedPeriodKey;
  final ValueChanged<String?> onPeriodSelected;

  @override
  Widget build(BuildContext context) {
    final List<_ChipData> chips = mode == PeriodMode.daily
        ? _buildDailyChips()
        : _buildMonthlyChips();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (BuildContext context, int index) {
          final _ChipData chip = chips[index];
          final bool isSelected = chip.key == selectedPeriodKey;

          return GestureDetector(
            onTap: () {
              if (isSelected) {
                onPeriodSelected(null);
              } else {
                onPeriodSelected(chip.key);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFD0D5D5),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                chip.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                      isSelected ? Colors.white : const Color(0xFF526565),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<_ChipData> _buildDailyChips() {
    final DateTime now = DateTime.now();
    final DateFormat dayFormat = DateFormat('MMM d');
    return List<_ChipData>.generate(7, (int i) {
      final DateTime date = now.subtract(Duration(days: i));
      final String key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final String label = i == 0 ? 'Today' : dayFormat.format(date);
      return _ChipData(key: key, label: label);
    });
  }

  List<_ChipData> _buildMonthlyChips() {
    final DateTime now = DateTime.now();
    final DateFormat monthFormat = DateFormat('MMM yy');
    return List<_ChipData>.generate(12, (int i) {
      final DateTime month = DateTime(now.year, now.month - i);
      final String key =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';
      final String label =
          i == 0 ? 'This Month' : monthFormat.format(month);
      return _ChipData(key: key, label: label);
    });
  }
}

class _ChipData {
  const _ChipData({required this.key, required this.label});

  final String key;
  final String label;
}
