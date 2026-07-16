import 'package:flutter/material.dart';

class SpecializationChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SpecializationChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutBack,
      scale: isSelected ? 1.03 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? colors.primary : const Color(0xFFE4E7EC),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? Colors.white : const Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) =>
                          RotationTransition(
                    turns: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: Icon(
                    isSelected ? Icons.close_rounded : Icons.add_rounded,
                    key: ValueKey<bool>(isSelected),
                    size: 15,
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
