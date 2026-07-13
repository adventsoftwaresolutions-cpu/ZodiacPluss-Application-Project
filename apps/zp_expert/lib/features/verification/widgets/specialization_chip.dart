import 'package:flutter/material.dart';

class SpecializationChip extends StatelessWidget {
  final String title;
  final VoidCallback? onRemove;

  const SpecializationChip({
    super.key,
    required this.title,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF5F7FA),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xffE4E7EC),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xff374151),
            ),
          ),

          const SizedBox(width: 8),

          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 15,
              color: Color(0xff6B7280),
            ),
          )
        ],
      ),
    );
  }
}