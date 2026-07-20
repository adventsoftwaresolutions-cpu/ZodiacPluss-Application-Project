import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/expert_profile.dart';
import '../data/provider/verification_form_provider.dart';
import 'section_card.dart';
import 'verification_dropdown.dart';

class ProfessionalInformationCard extends ConsumerWidget {
  const ProfessionalInformationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ExpertRole? selectedRole = ref.watch(
      verificationFormProvider.select(
        (VerificationFormState state) => state.form.profession,
      ),
    );
    final String? availability = ref.watch(
      verificationFormProvider.select(
        (VerificationFormState state) => state.form.availability,
      ),
    );
    final VerificationFormController controller =
        ref.read(verificationFormProvider.notifier);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Choose your expert path',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: 6),
          const Text(
            'We will personalise the remaining questions for your profession.',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final List<Widget> cards = ExpertRole.values
                  .map(
                    (ExpertRole role) => _ProfessionCard(
                      role: role,
                      selected: selectedRole == role,
                      enabled: role == ExpertRole.astrologer,
                      onTap: role == ExpertRole.astrologer
                          ? () => controller.setProfession(role)
                          : null,
                    ),
                  )
                  .toList();
              if (constraints.maxWidth < 430) {
                return Column(
                  children: <Widget>[
                    for (int index = 0; index < cards.length; index++) ...[
                      SizedBox(width: double.infinity, child: cards[index]),
                      if (index != cards.length - 1) const SizedBox(height: 10),
                    ],
                  ],
                );
              }
              return Row(
                children: <Widget>[
                  Expanded(child: cards.first),
                  const SizedBox(width: 12),
                  Expanded(child: cards.last),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          VerificationDropdown<String>(
            label: 'Availability',
            hint: 'Select availability',
            icon: Icons.schedule_rounded,
            value: availability,
            onChanged: (String? value) =>
                controller.updateProfessionalInfo(availability: value),
            items: const <DropdownMenuItem<String>>[
              DropdownMenuItem(value: 'Full Time', child: Text('Full Time')),
              DropdownMenuItem(value: 'Part Time', child: Text('Part Time')),
              DropdownMenuItem(
                value: 'Weekends',
                child: Text('Weekends'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfessionCard extends StatelessWidget {
  const _ProfessionCard({
    required this.role,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final ExpertRole role;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return Opacity(
      opacity: enabled ? 1 : .55,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: selected ? 1.02 : 1,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: selected
                    ? primary.withValues(alpha: .12)
                    : const Color(0xFFF7F9FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? primary : const Color(0xFFE5E7EB),
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor:
                        selected ? primary : const Color(0xFFE7EEEE),
                    foregroundColor: selected ? Colors.white : primary,
                    child: Icon(
                      role == ExpertRole.psychologist
                          ? Icons.psychology_outlined
                          : Icons.auto_awesome_outlined,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          role.label,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        if (!enabled)
                          const Text(
                            'Temporarily unavailable',
                            style: TextStyle(fontSize: 10),
                          ),
                      ],
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      !enabled
                          ? Icons.lock_outline_rounded
                          : selected
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                      key: ValueKey<String>('$selected-$enabled'),
                      color: selected ? primary : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
