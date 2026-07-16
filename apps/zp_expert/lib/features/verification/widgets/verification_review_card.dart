import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/data/expert_profile.dart';
import '../data/models/verification_form_model.dart';
import '../data/provider/verification_form_provider.dart';
import 'section_card.dart';

class VerificationReviewCard extends ConsumerWidget {
  const VerificationReviewCard({required this.onEditStep, super.key});

  final ValueChanged<int> onEditStep;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VerificationFormModel form = ref.watch(
      verificationFormProvider.select(
        (VerificationFormState state) => state.form,
      ),
    );
    final String role = form.profession?.label ?? 'Not selected';

    return Column(
      children: <Widget>[
        _ReviewWelcome(role: role),
        const SizedBox(height: 14),
        _ReviewSection(
          title: 'About you',
          icon: Icons.person_outline_rounded,
          onEdit: () => onEditStep(0),
          rows: <_ReviewRowData>[
            _ReviewRowData('Name', form.fullName),
            _ReviewRowData('Email', form.email),
            _ReviewRowData(
              'Date of birth',
              form.dateOfBirth == null
                  ? 'Not added'
                  : DateFormat('dd MMM yyyy').format(form.dateOfBirth!),
            ),
            _ReviewRowData('Languages', form.languages.join(', ')),
          ],
        ),
        const SizedBox(height: 14),
        _ReviewSection(
          title: 'Work style',
          icon: Icons.work_outline_rounded,
          onEdit: () => onEditStep(1),
          rows: <_ReviewRowData>[
            _ReviewRowData('Profession', role),
            _ReviewRowData('Availability', form.availability ?? 'Not added'),
            _ReviewRowData(
              'Other platform',
              form.worksOnOtherPlatform == true ? form.otherPlatformName : 'No',
            ),
            _ReviewRowData(
              'Daily contribution',
              '${form.dailyContributionHours} hours',
            ),
          ],
        ),
        const SizedBox(height: 14),
        _ReviewSection(
          title: 'Expertise',
          icon: form.profession == ExpertRole.astrologer
              ? Icons.auto_awesome_outlined
              : Icons.psychology_outlined,
          onEdit: () => onEditStep(2),
          rows: <_ReviewRowData>[
            _ReviewRowData('Experience', '${form.yearsExperience} years'),
            _ReviewRowData(
              'Specializations',
              form.specializations.join(', '),
            ),
            if (form.profession == ExpertRole.psychologist)
              _ReviewRowData(
                'Education',
                '${form.education.length} qualification(s)',
              ),
            if (form.profession == ExpertRole.astrologer)
              _ReviewRowData(
                'Learned astrology',
                form.astrologyLearningSource,
              ),
          ],
        ),
      ],
    );
  }
}

class _ReviewWelcome extends StatelessWidget {
  const _ReviewWelcome({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 25,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: .12),
              child: Icon(
                Icons.celebration_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'You are almost there!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Review your $role profile before submitting.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({
    required this.title,
    required this.icon,
    required this.onEdit,
    required this.rows,
  });

  final String title;
  final IconData icon;
  final VoidCallback onEdit;
  final List<_ReviewRowData> rows;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit'),
                ),
              ],
            ),
            const Divider(height: 20),
            ...rows.map(
              (_ReviewRowData row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 120,
                      child: Text(
                        row.label,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row.value.isEmpty ? 'Not added' : row.value,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _ReviewRowData {
  const _ReviewRowData(this.label, this.value);

  final String label;
  final String value;
}
