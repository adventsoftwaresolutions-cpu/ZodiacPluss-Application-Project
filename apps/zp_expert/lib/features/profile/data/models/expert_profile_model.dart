class ExpertProfileModel {
  const ExpertProfileModel({
    required this.name,
    required this.role,
    required this.avatarPath,
    required this.isVerified,
    required this.isOnline,
    required this.about,
    required this.yearsExperience,
    required this.education,
    required this.specializations,
    required this.introUploaded,
    required this.mediaCount,
    required this.consultationRates,
  });

  final String name;
  final String role;
  final String avatarPath;
  final bool isVerified;
  final bool isOnline;
  final String about;
  final int yearsExperience;
  final List<EducationEntry> education;
  final List<String> specializations;
  final bool introUploaded;
  final int mediaCount;
  final List<ConsultationRate> consultationRates;

  factory ExpertProfileModel.fromJson(Map<String, dynamic> json) {
    return ExpertProfileModel(
      name: json['name'] as String,
      role: json['role'] as String,
      avatarPath: json['avatarPath'] as String,
      isVerified: json['isVerified'] as bool,
      isOnline: json['isOnline'] as bool,
      about: json['about'] as String,
      yearsExperience: json['yearsExperience'] as int,
      education: (json['education'] as List<dynamic>)
          .map((dynamic value) =>
              EducationEntry.fromJson(value as Map<String, dynamic>))
          .toList(),
      specializations: List<String>.from(json['specializations'] as List),
      introUploaded: json['introUploaded'] as bool,
      mediaCount: json['mediaCount'] as int,
      consultationRates: (json['consultationRates'] as List<dynamic>)
          .map((dynamic value) =>
              ConsultationRate.fromJson(value as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'role': role,
        'avatarPath': avatarPath,
        'isVerified': isVerified,
        'isOnline': isOnline,
        'about': about,
        'yearsExperience': yearsExperience,
        'education':
            education.map((EducationEntry item) => item.toJson()).toList(),
        'specializations': specializations,
        'introUploaded': introUploaded,
        'mediaCount': mediaCount,
        'consultationRates': consultationRates
            .map((ConsultationRate item) => item.toJson())
            .toList(),
      };
}

class EducationEntry {
  const EducationEntry({
    required this.degree,
    required this.institution,
    required this.year,
  });

  final String degree;
  final String institution;
  final int year;

  factory EducationEntry.fromJson(Map<String, dynamic> json) => EducationEntry(
        degree: json['degree'] as String,
        institution: json['institution'] as String,
        year: json['year'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'degree': degree,
        'institution': institution,
        'year': year,
      };
}

class ConsultationRate {
  const ConsultationRate({required this.type, required this.ratePerMinute});

  final ConsultationType type;
  final int ratePerMinute;

  factory ConsultationRate.fromJson(Map<String, dynamic> json) =>
      ConsultationRate(
        type: ConsultationType.values.byName(json['type'] as String),
        ratePerMinute: json['ratePerMinute'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type.name,
        'ratePerMinute': ratePerMinute,
      };
}

enum ConsultationType {
  video('Video Rate'),
  voice('Voice Rate'),
  chat('Chat Rate');

  const ConsultationType(this.label);

  final String label;
}

class ProfileChangeRequest {
  const ProfileChangeRequest({
    required this.id,
    required this.section,
    required this.payload,
    required this.submittedAt,
  });

  final String id;
  final String section;
  final Map<String, dynamic> payload;
  final DateTime submittedAt;

  factory ProfileChangeRequest.fromJson(Map<String, dynamic> json) =>
      ProfileChangeRequest(
        id: json['id'] as String,
        section: json['section'] as String,
        payload: Map<String, dynamic>.from(json['payload'] as Map),
        submittedAt: DateTime.parse(json['submittedAt'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'section': section,
        'payload': payload,
        'submittedAt': submittedAt.toIso8601String(),
      };
}
