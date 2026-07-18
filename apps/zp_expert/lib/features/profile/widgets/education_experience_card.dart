import 'package:flutter/material.dart';

import '../../../shared/data/expert_profile.dart';
import 'profile_section_card.dart';

class EducationExperienceCard extends StatefulWidget {
  const EducationExperienceCard({
    required this.education,
    required this.yearsExperience,
    required this.onSubmit,
    super.key,
  });

  final List<EducationEntry> education;
  final int yearsExperience;
  final Future<void> Function(
    int yearsExperience,
    List<EducationEntry> education,
  ) onSubmit;

  @override
  State<EducationExperienceCard> createState() =>
      _EducationExperienceCardState();
}

class _EducationExperienceCardState extends State<EducationExperienceCard> {
  bool _isEditing = false;
  bool _isSaving = false;
  late int _draftYears;
  late List<_EducationDraft> _draftEducation;

  @override
  void initState() {
    super.initState();
    _draftYears = widget.yearsExperience;
    _draftEducation = <_EducationDraft>[];
  }

  void _createDraft() {
    _draftYears = widget.yearsExperience;
    _draftEducation = widget.education
        .map((EducationEntry entry) => _EducationDraft.fromEntry(entry))
        .toList();
  }

  void _disposeDraft() {
    for (final _EducationDraft draft in _draftEducation) {
      draft.dispose();
    }
    _draftEducation = <_EducationDraft>[];
  }

  @override
  void dispose() {
    _disposeDraft();
    super.dispose();
  }

  Future<void> _handleAction() async {
    if (!_isEditing) {
      _createDraft();
      setState(() => _isEditing = true);
      return;
    }
    setState(() => _isSaving = true);
    await widget.onSubmit(
      _draftYears,
      _draftEducation.map((_EducationDraft item) => item.toEntry()).toList(),
    );
    if (!mounted) return;
    setState(() {
      _isEditing = false;
      _isSaving = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _disposeDraft();
    });
  }

  @override
  Widget build(BuildContext context) => ProfileSectionCard(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          child: Column(
            children: <Widget>[
              ProfileSectionTitle(
                icon: Icons.school_outlined,
                title: 'Education & Experience',
                action: ProfileEditButton(
                  isEditing: _isEditing,
                  onPressed: _isSaving ? null : _handleAction,
                ),
              ),
              const SizedBox(height: 12),
              if (_isEditing) _buildEditor(context) else _buildSummary(context),
            ],
          ),
        ),
      );

  Widget _buildSummary(BuildContext context) => Column(
        children: <Widget>[
          ...widget.education.map(
            (EducationEntry item) => _TimelineEntry(
              title: item.degree,
              subtitle: '${item.institution}  |  ${item.year}',
            ),
          ),
          _TimelineEntry(
            title:
                '${widget.yearsExperience}+ years of Professional Experience',
            subtitle: 'Experience supporting clients across mental wellness',
            isLast: true,
          ),
        ],
      );

  Widget _buildEditor(BuildContext context) => Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Text('Professional experience',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                IconButton(
                  onPressed: _draftYears > 0
                      ? () => setState(() => _draftYears--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$_draftYears years',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                IconButton(
                  onPressed: () => setState(() => _draftYears++),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...List<Widget>.generate(
            _draftEducation.length,
            (int index) {
              final _EducationDraft draft = _draftEducation[index];
              return _EducationEditor(
                key: ValueKey<_EducationDraft>(draft),
                draft: draft,
                onRemove: () {
                  setState(() => _draftEducation.removeAt(index));
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    draft.dispose();
                  });
                },
              );
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(
                () => _draftEducation.add(_EducationDraft.empty()),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add qualification'),
            ),
          ),
        ],
      );
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final bool isLast;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: .35),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _EducationEditor extends StatelessWidget {
  const _EducationEditor({
    required this.draft,
    required this.onRemove,
    super.key,
  });

  final _EducationDraft draft;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .72),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Expanded(
                  child: Text('Qualification',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            TextField(
              controller: draft.degree,
              decoration: const InputDecoration(
                labelText: 'Degree',
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: draft.institution,
                    decoration: const InputDecoration(
                      labelText: 'Institution',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: draft.year,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _EducationDraft {
  _EducationDraft({
    required this.degree,
    required this.institution,
    required this.year,
  });

  factory _EducationDraft.fromEntry(EducationEntry entry) => _EducationDraft(
        degree: TextEditingController(text: entry.degree),
        institution: TextEditingController(text: entry.institution),
        year: TextEditingController(text: '${entry.year}'),
      );

  factory _EducationDraft.empty() => _EducationDraft(
        degree: TextEditingController(),
        institution: TextEditingController(),
        year: TextEditingController(text: '${DateTime.now().year}'),
      );

  final TextEditingController degree;
  final TextEditingController institution;
  final TextEditingController year;

  void dispose() {
    degree.dispose();
    institution.dispose();
    year.dispose();
  }

  EducationEntry toEntry() => EducationEntry(
        degree:
            degree.text.trim().isEmpty ? 'Qualification' : degree.text.trim(),
        institution: institution.text.trim().isEmpty
            ? 'Institution'
            : institution.text.trim(),
        year: int.tryParse(year.text) ?? DateTime.now().year,
      );
}
