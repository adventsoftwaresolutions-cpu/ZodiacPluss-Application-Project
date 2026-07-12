import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'in_memeory_mood_repo.dart';
import 'mood_repositiory.dart';

part 'mood_provider.g.dart';

@riverpod
MoodRepository moodRepository(Ref ref) {
  // I have to swap this single line for SupabaseMoodRepository() later.
  return InMemoryMoodRepository();
}