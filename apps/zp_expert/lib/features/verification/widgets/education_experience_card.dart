import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/expert_profile.dart';
import '../data/models/verification_form_model.dart';
import '../data/provider/verification_form_provider.dart';
import 'section_card.dart';
import 'verification_input.dart';

class VerificationEducationExperienceCard extends ConsumerWidget {
  const VerificationEducationExperienceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VerificationFormModel form = ref.watch(
      verificationFormProvider.select(
        (VerificationFormState state) => state.form,
      ),
    );
    final VerificationFormController controller =
        ref.read(verificationFormProvider.notifier);
    final bool needsEducation = form.profession == ExpertRole.psychologist;

    return SectionCard(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              needsEducation ? 'Education & Experience' : 'Your Experience',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              needsEducation
                  ? 'Add your professional experience and education history.'
                  : 'How long have you been guiding clients through astrology?',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 18),
            _ExperienceCounter(
              years: form.yearsExperience,
              onChanged: controller.setYearsExperience,
            ),
            if (needsEducation) ...<Widget>[
              const SizedBox(height: 14),
              if (form.education.isEmpty)
                const _EmptyEducation()
              else
                ...form.education.map(
                  (VerificationEducationEntry entry) =>
                      _VerificationEducationEditor(
                    key: ValueKey<String>(entry.id),
                    entry: entry,
                    onChanged: controller.updateEducation,
                    onRemove: () => controller.removeEducation(entry.id),
                  ),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: controller.addEducation,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add education'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExperienceCounter extends StatelessWidget {
  const _ExperienceCounter({required this.years, required this.onChanged});

  final int years;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: .72),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget controls = Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: years > 0 ? () => onChanged(years - 1) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: Text(
                    '$years years',
                    key: ValueKey<int>(years),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: years < 60 ? () => onChanged(years + 1) : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            );
            const Widget label = Text(
              'Professional experience',
              style: TextStyle(fontWeight: FontWeight.w600),
            );

            if (constraints.maxWidth < 340) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  label,
                  Align(alignment: Alignment.centerRight, child: controls),
                ],
              );
            }
            return Row(
              children: <Widget>[
                const Expanded(child: label),
                controls,
              ],
            );
          },
        ),
      );
}

class _EmptyEducation extends StatelessWidget {
  const _EmptyEducation();

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'No qualification added yet.',
          style: TextStyle(color: Color(0xFF6B7280)),
        ),
      );
}

class _VerificationEducationEditor extends StatefulWidget {
  const _VerificationEducationEditor({
    required this.entry,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final VerificationEducationEntry entry;
  final ValueChanged<VerificationEducationEntry> onChanged;
  final VoidCallback onRemove;

  @override
  State<_VerificationEducationEditor> createState() =>
      _VerificationEducationEditorState();
}

class _VerificationEducationEditorState
    extends State<_VerificationEducationEditor> {
  late final TextEditingController _degreeController;
  late final TextEditingController _institutionController;
  late final TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _degreeController = TextEditingController(text: widget.entry.degree);
    _institutionController =
        TextEditingController(text: widget.entry.institution);
    _yearController = TextEditingController(
      text: widget.entry.year == 0 ? '' : '${widget.entry.year}',
    );
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: .76),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Expanded(
                  child: Text(
                    'Qualification',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  tooltip: 'Remove qualification',
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            VerificationInput(
              label: 'Degree',
              hint: 'e.g. MA Clinical Psychology',
              icon: Icons.school_outlined,
              controller: _degreeController,
              onChanged: (String value) =>
                  widget.onChanged(widget.entry.copyWith(degree: value)),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Widget institution = VerificationInput(
                  label: 'Institution',
                  hint: 'University or institution',
                  icon: Icons.account_balance_outlined,
                  controller: _institutionController,
                  onChanged: (String value) => widget
                      .onChanged(widget.entry.copyWith(institution: value)),
                );
                final Widget year = VerificationInput(
                  label: 'Year',
                  hint: 'YYYY',
                  icon: Icons.calendar_today_outlined,
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  onChanged: (String value) => widget.onChanged(
                    widget.entry.copyWith(year: int.tryParse(value) ?? 0),
                  ),
                );

                if (constraints.maxWidth < 420) {
                  return Column(
                    children: <Widget>[
                      institution,
                      const SizedBox(height: 12),
                      year,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(flex: 2, child: institution),
                    const SizedBox(width: 12),
                    Expanded(child: year),
                  ],
                );
              },
            ),
          ],
        ),
      );
}
