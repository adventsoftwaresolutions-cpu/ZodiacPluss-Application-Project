import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../data/mood_entry.dart';
import '../data/mood_provider.dart';
import '../../../shared/models/mood_items.dart';

class MoodTrackerWidget extends ConsumerStatefulWidget {
  const MoodTrackerWidget({super.key});

  @override
  ConsumerState<MoodTrackerWidget> createState() => _MoodTrackerWidgetState();
}

class _MoodTrackerWidgetState extends ConsumerState<MoodTrackerWidget> {
  MoodItem? _selectedMood;
  final _noteController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onMoodTap(MoodItem mood) {
    setState(() {
      _selectedMood = _selectedMood?.type == mood.type ? null : mood;
    });
  }

  Future<void> _submit() async {
    final mood = _selectedMood;
    if (mood == null || _noteController.text.trim().isEmpty) return;

    setState(() => _isSaving = true);

    final repo = ref.read(moodRepositoryProvider);
    await repo.saveMoodEntry(
      MoodEntry(
        mood: mood.type,
        note: _noteController.text.trim(),
        createdAt: DateTime.now(),
      ),
    );

    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _selectedMood = null;
      _noteController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mood logged')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 16),
            _buildMoodRow(),
            if (_selectedMood != null) ...[
              const SizedBox(height: 20),
              _buildExpandedInput(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.green.shade600,
          child: const Icon(Icons.sentiment_satisfied_alt, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mood Tracker', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text('How are you feeling today?', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: () {}, // wire to calendar route
          icon: const Icon(Icons.calendar_today_outlined, size: 12),
          label: const Text('View Calendar'),
        ),
      ],
    );
  }

  Widget _buildMoodRow() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kMoodItems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final mood = kMoodItems[index];
          final isSelected = _selectedMood?.type == mood.type;
          return _MoodCard(
            mood: mood,
            isSelected: isSelected,
            onTap: () => _onMoodTap(mood),
          );
        },
      ),
    );
  }

  Widget _buildExpandedInput(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tell us more about feeling ${_selectedMood!.label.toLowerCase()}',
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        AppTextField(
          controller: _noteController,
          hintText: 'Explain your mood...',
          maxLines: 3,
          autofocus: true,
          textInputAction: TextInputAction.newline,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: _isSaving ? null : _submit,
            child: _isSaving
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Submit'),
          ),
        ),
      ],
    );
  }
}

class _MoodCard extends StatelessWidget {
  const _MoodCard({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  final MoodItem mood;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 65,
        decoration: BoxDecoration(
          color: mood.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.green.shade600 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(mood.assetPath, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(mood.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}