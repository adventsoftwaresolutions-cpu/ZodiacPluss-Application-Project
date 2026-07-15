import 'package:flutter/material.dart';

import 'profile_section_card.dart';

class SpecializationsCard extends StatefulWidget {
  const SpecializationsCard({
    required this.selected,
    required this.onSubmit,
    super.key,
  });

  final List<String> selected;
  final Future<void> Function(List<String> values) onSubmit;

  @override
  State<SpecializationsCard> createState() => _SpecializationsCardState();
}

class _SpecializationsCardState extends State<SpecializationsCard> {
  static const List<String> _allOptions = <String>[
    'Stress Management',
    'Depression',
    'Self Esteem',
    'Anxiety',
    'Relationships',
    'Trauma Recovery',
    'Grief Support',
    'Sleep Issues',
    'Mindfulness',
    'Career Guidance',
    'Family Therapy',
    'Workplace Wellness',
  ];

  late Set<String> _draft;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _draft = widget.selected.toSet();
  }

  Future<void> _handleAction() async {
    if (!_isEditing) {
      setState(() => _isEditing = true);
      return;
    }
    setState(() => _isSaving = true);
    await widget.onSubmit(_draft.toList());
    if (!mounted) return;
    setState(() {
      _draft = widget.selected.toSet();
      _isEditing = false;
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> visible = _isEditing ? _allOptions : widget.selected;
    return ProfileSectionCard(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: Column(
          children: <Widget>[
            ProfileSectionTitle(
              icon: Icons.star_outline_rounded,
              title: 'Specializations',
              action: ProfileEditButton(
                isEditing: _isEditing,
                onPressed: _isSaving ? null : _handleAction,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 9,
                children: visible.map((String label) {
                  final bool isSelected = _draft.contains(label);
                  return _isEditing
                      ? AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: isSelected ? 1 : .72,
                          child: ActionChip(
                            onPressed: () => setState(() {
                              isSelected
                                  ? _draft.remove(label)
                                  : _draft.add(label);
                            }),
                            avatar: Icon(
                              isSelected
                                  ? Icons.close_rounded
                                  : Icons.add_rounded,
                              size: 16,
                              color: isSelected ? Colors.white : null,
                            ),
                            label: Text(label),
                            side: BorderSide.none,
                            backgroundColor: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : const Color(0xFFE1ECEC),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                      : Chip(
                          label: Text(label),
                          side: BorderSide.none,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: .14),
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          visualDensity: VisualDensity.compact,
                        );
                }).toList(),
              ),
            ),
            if (_isEditing) ...<Widget>[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_draft.length} selected · Tap x to remove or + to add',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
