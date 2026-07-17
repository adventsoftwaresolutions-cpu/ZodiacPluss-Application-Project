import 'package:flutter/material.dart';

import '../../../themes/app_radius.dart';
import '../data/models/chat_conversation_model.dart';
import '../data/models/session_summary_model.dart';

typedef SaveSessionSummary = Future<void> Function({
  required String presentingConcern,
  required String summaryNote,
  required String homework,
  required List<RecommendedExercise> exercises,
});

class SessionSummarySheet extends StatefulWidget {
  const SessionSummarySheet({
    required this.conversation,
    required this.onSave,
    this.summary,
    super.key,
  });

  final ChatConversationModel conversation;
  final SaveSessionSummary onSave;
  final SessionSummaryModel? summary;

  @override
  State<SessionSummarySheet> createState() => _SessionSummarySheetState();
}

class _SessionSummarySheetState extends State<SessionSummarySheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _presentingController;
  late final TextEditingController _summaryController;
  late final TextEditingController _homeworkController;
  late final Set<RecommendedExercise> _exercises;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final SessionSummaryModel? summary = widget.summary;
    _presentingController =
        TextEditingController(text: summary?.presentingConcern);
    _summaryController = TextEditingController(text: summary?.summaryNote);
    _homeworkController = TextEditingController(text: summary?.homework);
    _exercises = <RecommendedExercise>{...?summary?.exercises};
  }

  @override
  void dispose() {
    _presentingController.dispose();
    _summaryController.dispose();
    _homeworkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: .91,
          minChildSize: .55,
          maxChildSize: .96,
          builder: (BuildContext context, ScrollController scrollController) =>
              Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    children: <Widget>[
                      const _SheetHandle(),
                      const SizedBox(height: 12),
                      _SheetHeading(
                        editing: widget.summary != null,
                      ),
                      const SizedBox(height: 18),
                      _ReadOnlyConcern(
                        concern: widget.conversation.userConcern,
                      ),
                      const SizedBox(height: 16),
                      _SummaryField(
                        key: const ValueKey<String>(
                          'presenting-concern-field',
                        ),
                        controller: _presentingController,
                        label: 'Presenting concern',
                        hint:
                            'Describe the concern in your clinical understanding',
                        requiredField: true,
                      ),
                      const SizedBox(height: 14),
                      _SummaryField(
                        key: const ValueKey<String>('session-note-field'),
                        controller: _summaryController,
                        label: 'Session note (optional)',
                        hint: 'Leave a concise note for the client',
                        minLines: 3,
                      ),
                      const SizedBox(height: 14),
                      _SummaryField(
                        key: const ValueKey<String>('homework-field'),
                        controller: _homeworkController,
                        label: 'Homework',
                        hint: 'Add a task or reflection for the client',
                        minLines: 2,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Recommended exercises',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select any that support the follow-up plan.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF647373),
                            ),
                      ),
                      const SizedBox(height: 10),
                      _ExercisePicker(
                        selected: _exercises,
                        onChanged: () => setState(() {}),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: _FormActions(
                    saving: _saving,
                    onSkip: () => Navigator.of(context).pop(),
                    onSave: _save,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    await widget.onSave(
      presentingConcern: _presentingController.text.trim(),
      summaryNote: _summaryController.text.trim(),
      homework: _homeworkController.text.trim(),
      exercises: _exercises.toList(),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 42,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
}

class _SheetHeading extends StatelessWidget {
  const _SheetHeading({required this.editing});

  final bool editing;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: .12),
            foregroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.note_alt_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  editing ? 'Edit session summary' : 'Complete session summary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const Text('A clear, supportive follow-up for the client.'),
              ],
            ),
          ),
        ],
      );
}

class _ReadOnlyConcern extends StatelessWidget {
  const _ReadOnlyConcern({required this.concern});

  final String concern;

  @override
  Widget build(BuildContext context) => Container(
        key: const ValueKey<String>('read-only-user-concern'),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .14),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.lock_outline_rounded,
              size: 19,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'User concern',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(concern),
                  const SizedBox(height: 5),
                  const Text(
                    'Submitted during booking and cannot be edited.',
                    style: TextStyle(fontSize: 10, color: Color(0xFF637272)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _SummaryField extends StatelessWidget {
  const _SummaryField({
    required this.controller,
    required this.label,
    required this.hint,
    this.minLines = 2,
    this.requiredField = false,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int minLines;
  final bool requiredField;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: minLines + 2,
        textCapitalization: TextCapitalization.sentences,
        validator: requiredField
            ? (String? value) => value == null || value.trim().isEmpty
                ? 'Please add the presenting concern.'
                : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: BorderSide.none,
          ),
        ),
      );
}

class _ExercisePicker extends StatelessWidget {
  const _ExercisePicker({required this.selected, required this.onChanged});

  final Set<RecommendedExercise> selected;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: RecommendedExercise.values.map((RecommendedExercise item) {
          final bool isSelected = selected.contains(item);
          return FilterChip(
            label: Text(item.label),
            selected: isSelected,
            avatar: Icon(
              isSelected ? Icons.check_rounded : Icons.add_rounded,
              size: 17,
            ),
            onSelected: (bool value) {
              value ? selected.add(item) : selected.remove(item);
              onChanged();
            },
          );
        }).toList(),
      );
}

class _FormActions extends StatelessWidget {
  const _FormActions({
    required this.saving,
    required this.onSkip,
    required this.onSave,
  });

  final bool saving;
  final VoidCallback onSkip;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              onPressed: saving ? null : onSkip,
              child: const Text('Skip for now'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: FilledButton.icon(
              key: const ValueKey<String>('save-session-summary'),
              onPressed: saving ? null : onSave,
              icon: saving
                  ? const SizedBox.square(
                      dimension: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_rounded),
              label: Text(saving ? 'Saving…' : 'Share in chat'),
            ),
          ),
        ],
      );
}
