import 'package:flutter/foundation.dart';

enum ExpertRole { psychologist, astrologer }

extension ExpertRoleLabel on ExpertRole {
  String get label => switch (this) {
        ExpertRole.psychologist => 'Psychologist',
        ExpertRole.astrologer => 'Astrologer',
      };
}

@immutable
class ExpertProfile {
  const ExpertProfile({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.isVerified,
    this.about = '',
    this.yearsExperience = 0,
    this.education = const <EducationEntry>[],
    this.specializations = const <String>[],
    this.introUploaded = false,
    this.mediaCount = 0,
    this.consultationRates = const <ConsultationRate>[],
  });

  factory ExpertProfile.fromJson(Map<String, dynamic> json) => ExpertProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        role: ExpertRole.values.byName(json['role'] as String),
        avatarUrl: json['avatarUrl'] as String,
        isVerified: json['isVerified'] as bool,
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

  final String id;
  final String name;
  final ExpertRole role;
  final String avatarUrl;
  final bool isVerified;
  final String about;
  final int yearsExperience;
  final List<EducationEntry> education;
  final List<String> specializations;
  final bool introUploaded;
  final int mediaCount;
  final List<ConsultationRate> consultationRates;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'role': role.name,
        'avatarUrl': avatarUrl,
        'isVerified': isVerified,
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

@immutable
class EducationEntry {
  const EducationEntry({
    required this.degree,
    required this.institution,
    required this.year,
  });

  factory EducationEntry.fromJson(Map<String, dynamic> json) => EducationEntry(
        degree: json['degree'] as String,
        institution: json['institution'] as String,
        year: json['year'] as int,
      );

  final String degree;
  final String institution;
  final int year;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'degree': degree,
        'institution': institution,
        'year': year,
      };
}

@immutable
class ConsultationRate {
  const ConsultationRate({required this.type, required this.ratePerMinute});

  factory ConsultationRate.fromJson(Map<String, dynamic> json) =>
      ConsultationRate(
        type: ConsultationType.values.byName(json['type'] as String),
        ratePerMinute: json['ratePerMinute'] as int,
      );

  final ConsultationType type;
  final int ratePerMinute;

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
