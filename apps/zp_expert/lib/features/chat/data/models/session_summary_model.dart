enum RecommendedExercise {
  boxBreathing('Box breathing'),
  grounding('5-4-3-2-1 grounding'),
  journaling('Guided journaling'),
  mindfulness('Mindfulness practice'),
  muscleRelaxation('Progressive muscle relaxation'),
  thoughtReframing('Thought reframing');

  const RecommendedExercise(this.label);

  final String label;
}

class SessionSummaryModel {
  const SessionSummaryModel({
    required this.id,
    required this.sessionId,
    required this.userConcern,
    required this.presentingConcern,
    required this.summaryNote,
    required this.homework,
    required this.exercises,
    required this.createdAt,
  });

  final String id;
  final String sessionId;
  final String userConcern;
  final String presentingConcern;
  final String summaryNote;
  final String homework;
  final List<RecommendedExercise> exercises;
  final DateTime createdAt;

  SessionSummaryModel copyWith({
    String? presentingConcern,
    String? summaryNote,
    String? homework,
    List<RecommendedExercise>? exercises,
    DateTime? createdAt,
  }) =>
      SessionSummaryModel(
        id: id,
        sessionId: sessionId,
        userConcern: userConcern,
        presentingConcern: presentingConcern ?? this.presentingConcern,
        summaryNote: summaryNote ?? this.summaryNote,
        homework: homework ?? this.homework,
        exercises: exercises ?? this.exercises,
        createdAt: createdAt ?? this.createdAt,
      );

  factory SessionSummaryModel.fromJson(Map<String, dynamic> json) =>
      SessionSummaryModel(
        id: json['id'] as String,
        sessionId: json['sessionId'] as String,
        userConcern: json['userConcern'] as String,
        presentingConcern: json['presentingConcern'] as String,
        summaryNote: json['summaryNote'] as String? ?? '',
        homework: json['homework'] as String? ?? '',
        exercises: (json['exercises'] as List<dynamic>? ?? <dynamic>[])
            .map((dynamic value) =>
                RecommendedExercise.values.byName(value as String))
            .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'sessionId': sessionId,
        'userConcern': userConcern,
        'presentingConcern': presentingConcern,
        'summaryNote': summaryNote,
        'homework': homework,
        'exercises': exercises
            .map((RecommendedExercise exercise) => exercise.name)
            .toList(),
        'createdAt': createdAt.toIso8601String(),
      };
}
