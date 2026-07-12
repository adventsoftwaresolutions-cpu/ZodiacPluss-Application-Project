import 'package:zp_client/shared/models/mood_items.dart';

class MoodEntry {
  MoodEntry({
    required this.mood,
    required this.note,
    required this.createdAt,
  });

  final MoodType mood;
  final String note;
  final DateTime createdAt;
}