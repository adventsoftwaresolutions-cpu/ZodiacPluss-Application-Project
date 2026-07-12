import 'package:flutter/material.dart';

enum MoodType { joy, sadness, anger, fear, surprise, disgust, calm }

class MoodItem {
  const MoodItem({
    required this.type,
    required this.label,
    required this.assetPath,
    required this.backgroundColor,
  });

  final MoodType type;
  final String label;
  final String assetPath;
  final Color backgroundColor;
}

const List<MoodItem> kMoodItems = [
  MoodItem(
    type: MoodType.joy,
    label: 'Joy',
    assetPath: 'assets/images/mood_joy.png',
    backgroundColor: Color(0xFFFFF6DD),
  ),
  MoodItem(
    type: MoodType.sadness,
    label: 'Sadness',
    assetPath: 'assets/images/mood_sadness.png',
    backgroundColor: Color(0xFFE9F1FB),
  ),
  MoodItem(
    type: MoodType.anger,
    label: 'Anger',
    assetPath: 'assets/images/mood_anger.png',
    backgroundColor: Color(0xFFFCEAE3),
  ),
  MoodItem(
    type: MoodType.fear,
    label: 'Fear',
    assetPath: 'assets/images/mood_fear.png',
    backgroundColor: Color(0xFFF1EAFB),
  ),
  MoodItem(
    type: MoodType.surprise,
    label: 'Surprise',
    assetPath: 'assets/images/mood_surprise.png',
    backgroundColor: Color(0xFFFFF8DD),
  ),
  MoodItem(
    type: MoodType.disgust,
    label: 'Disgust',
    assetPath: 'assets/images/mood_disgust.png',
    backgroundColor: Color(0xFFF3F9E4),
  ),
  MoodItem(
    type: MoodType.calm,
    label: 'Calm',
    assetPath: 'assets/images/mood_calm.png',
    backgroundColor: Color(0xFFE6F5F0),
  ),
];