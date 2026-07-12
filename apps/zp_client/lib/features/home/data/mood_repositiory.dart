import 'mood_entry.dart';

/// Abstract contract. UI code depends on THIS, never on the concrete impl.
abstract class MoodRepository {
  Future<void> saveMoodEntry(MoodEntry entry);
  Future<List<MoodEntry>> getTodayEntries();
}