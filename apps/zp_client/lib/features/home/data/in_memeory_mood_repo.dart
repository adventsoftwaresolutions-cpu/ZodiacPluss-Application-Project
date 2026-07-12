import 'mood_entry.dart';
import 'mood_repositiory.dart';

/// Volatile, in-memory only — cleared on app close. This is what you
/// swap out for a SupabaseMoodRepository later. Nothing outside this
/// file needs to change when you do that swap.
class InMemoryMoodRepository implements MoodRepository {
  final List<MoodEntry> _entries = [];

  @override
  Future<void> saveMoodEntry(MoodEntry entry) async {
    _entries.add(entry);
  }

  @override
  Future<List<MoodEntry>> getTodayEntries() async {
    final now = DateTime.now();
    return _entries
        .where((e) =>
            e.createdAt.year == now.year &&
            e.createdAt.month == now.month &&
            e.createdAt.day == now.day)
        .toList();
  }
}