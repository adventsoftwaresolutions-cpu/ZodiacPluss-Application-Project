import 'package:flutter/material.dart';

import 'section_card.dart';
import 'specialization_chip.dart';

class SpecializationCard extends StatelessWidget {
  const SpecializationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "3. Specializations",
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xff111827),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Select the areas you specialize in.",
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: const Color(0xff6B7280),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              SpecializationChip(title: "Anxiety"),
              SpecializationChip(title: "Depression"),
              SpecializationChip(title: "Stress"),
              SpecializationChip(title: "Career"),
              SpecializationChip(title: "Relationship"),
              SpecializationChip(title: "Trauma"),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.add_rounded,
                size: 16,
              ),
              label: const Text(
                "Add Specialization",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(
                  color: Color(0xffD8DEE7),
                  width: 1,
                ),
                foregroundColor: const Color(0xff374151),
              ),
            ),
          ),
        ],
      ),
    );
  }
}