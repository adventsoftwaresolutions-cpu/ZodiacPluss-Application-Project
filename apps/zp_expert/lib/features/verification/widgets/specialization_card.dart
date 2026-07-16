import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/constants/expert_specializations.dart';
import '../../../shared/data/expert_profile.dart';
import '../data/provider/verification_form_provider.dart';
import 'section_card.dart';
import 'specialization_chip.dart';

class SpecializationCard extends ConsumerWidget {
  const SpecializationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final VerificationFormState formState = ref.watch(
      verificationFormProvider.select(
        (VerificationFormState state) => state,
      ),
    );
    final List<String> selected = formState.form.specializations;
    final ExpertRole role =
        formState.form.profession ?? ExpertRole.psychologist;
    final List<String> options = ExpertSpecializations.forRole(role);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${role.label} specializations',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xff111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role == ExpertRole.psychologist
                ? 'Select the areas you support clients with.'
                : 'Select the astrology services you are confident offering.',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: const Color(0xff6B7280),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.map((String title) {
                  final bool isSelected = selected.contains(title);
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: SpecializationChip(
                      title: title,
                      isSelected: isSelected,
                      onTap: () => ref
                          .read(verificationFormProvider.notifier)
                          .toggleSpecialization(title),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Text(
              '${selected.length} selected · Tap + to add or × to remove',
              key: ValueKey<int>(selected.length),
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
