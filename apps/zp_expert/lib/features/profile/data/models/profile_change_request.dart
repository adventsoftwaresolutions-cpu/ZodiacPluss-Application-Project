class ProfileChangeRequest {
  const ProfileChangeRequest({
    required this.id,
    required this.section,
    required this.payload,
    required this.submittedAt,
  });

  factory ProfileChangeRequest.fromJson(Map<String, dynamic> json) =>
      ProfileChangeRequest(
        id: json['id'] as String,
        section: json['section'] as String,
        payload: Map<String, dynamic>.from(json['payload'] as Map),
        submittedAt: DateTime.parse(json['submittedAt'] as String),
      );

  final String id;
  final String section;
  final Map<String, dynamic> payload;
  final DateTime submittedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'section': section,
        'payload': payload,
        'submittedAt': submittedAt.toIso8601String(),
      };
}
