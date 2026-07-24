import '../../../../shared/data/expert_profile.dart';

class VerificationFormModel {
  const VerificationFormModel({
    required this.fullName,
    required this.email,
    required this.address,
    required this.gender,
    required this.dateOfBirth,
    required this.languages,
    required this.profession,
    required this.availability,
    required this.worksOnOtherPlatform,
    required this.otherPlatformName,
    required this.dailyContributionHours,
    required this.yearsExperience,
    required this.education,
    required this.specializations,
    required this.astrologyLearningSource,
    required this.qualificationFileName,
    required this.profilePhotoSource,
  });

  factory VerificationFormModel.initial() => const VerificationFormModel(
        fullName: '',
        email: '',
        address: '',
        gender: null,
        dateOfBirth: null,
        languages: <String>[],
        profession: null,
        availability: null,
        worksOnOtherPlatform: null,
        otherPlatformName: '',
        dailyContributionHours: 0,
        yearsExperience: 0,
        education: <VerificationEducationEntry>[],
        specializations: <String>[],
        astrologyLearningSource: '',
        qualificationFileName: null,
        profilePhotoSource: null,
      );

  final String fullName;
  final String email;
  final String address;
  final String? gender;
  final DateTime? dateOfBirth;
  final List<String> languages;
  final ExpertRole? profession;
  final String? availability;
  final bool? worksOnOtherPlatform;
  final String otherPlatformName;
  final int dailyContributionHours;
  final int yearsExperience;
  final List<VerificationEducationEntry> education;
  final List<String> specializations;
  final String astrologyLearningSource;
  final String? qualificationFileName;
  final String? profilePhotoSource;

  VerificationFormModel copyWith({
    String? fullName,
    String? email,
    String? address,
    String? gender,
    DateTime? dateOfBirth,
    List<String>? languages,
    ExpertRole? profession,
    String? availability,
    bool? worksOnOtherPlatform,
    String? otherPlatformName,
    int? dailyContributionHours,
    int? yearsExperience,
    List<VerificationEducationEntry>? education,
    List<String>? specializations,
    String? astrologyLearningSource,
    String? qualificationFileName,
    String? profilePhotoSource,
    bool clearQualification = false,
    bool clearProfilePhoto = false,
    bool clearProfession = false,
    bool clearOtherPlatformChoice = false,
    bool clearDateOfBirth = false,
  }) =>
      VerificationFormModel(
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        address: address ?? this.address,
        gender: gender ?? this.gender,
        dateOfBirth: clearDateOfBirth ? null : dateOfBirth ?? this.dateOfBirth,
        languages: languages ?? this.languages,
        profession: clearProfession ? null : profession ?? this.profession,
        availability: availability ?? this.availability,
        worksOnOtherPlatform: clearOtherPlatformChoice
            ? null
            : worksOnOtherPlatform ?? this.worksOnOtherPlatform,
        otherPlatformName: otherPlatformName ?? this.otherPlatformName,
        dailyContributionHours:
            dailyContributionHours ?? this.dailyContributionHours,
        yearsExperience: yearsExperience ?? this.yearsExperience,
        education: education ?? this.education,
        specializations: specializations ?? this.specializations,
        astrologyLearningSource:
            astrologyLearningSource ?? this.astrologyLearningSource,
        qualificationFileName: clearQualification
            ? null
            : qualificationFileName ?? this.qualificationFileName,
        profilePhotoSource: clearProfilePhoto
            ? null
            : profilePhotoSource ?? this.profilePhotoSource,
      );

  factory VerificationFormModel.fromJson(Map<String, dynamic> json) =>
      VerificationFormModel(
        fullName: json['fullName'] as String? ?? '',
        email: json['email'] as String? ?? '',
        address: json['address'] as String? ?? '',
        gender: json['gender'] as String?,
        dateOfBirth: DateTime.tryParse(json['dateOfBirth'] as String? ?? ''),
        languages: List<String>.from(json['languages'] as List? ?? <String>[]),
        profession: _roleFromJson(json['profession'] as String?),
        availability: json['availability'] as String?,
        worksOnOtherPlatform: json['worksOnOtherPlatform'] as bool?,
        otherPlatformName: json['otherPlatformName'] as String? ?? '',
        dailyContributionHours: json['dailyContributionHours'] as int? ?? 0,
        yearsExperience: json['yearsExperience'] as int? ?? 0,
        education: (json['education'] as List<dynamic>? ?? <dynamic>[])
            .map((dynamic item) => VerificationEducationEntry.fromJson(
                item as Map<String, dynamic>))
            .toList(),
        specializations:
            List<String>.from(json['specializations'] as List? ?? <String>[]),
        astrologyLearningSource:
            json['astrologyLearningSource'] as String? ?? '',
        qualificationFileName: json['qualificationFileName'] as String?,
        profilePhotoSource: json['profilePhotoSource'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'fullName': fullName,
        'email': email,
        'address': address,
        'gender': gender,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'languages': languages,
        'profession': profession?.name,
        'availability': availability,
        'worksOnOtherPlatform': worksOnOtherPlatform,
        'otherPlatformName': otherPlatformName,
        'dailyContributionHours': dailyContributionHours,
        'yearsExperience': yearsExperience,
        'education': education
            .map((VerificationEducationEntry item) => item.toJson())
            .toList(),
        'specializations': specializations,
        'astrologyLearningSource': profession == ExpertRole.astrologer
            ? astrologyLearningSource
            : null,
        'qualificationFileName': qualificationFileName,
        'profilePhotoSource': profilePhotoSource,
      };

  static ExpertRole? _roleFromJson(String? value) {
    if (value == null) return null;
    for (final ExpertRole role in ExpertRole.values) {
      if (role.name == value || role.label == value) return role;
    }
    return null;
  }
}

class VerificationEducationEntry {
  const VerificationEducationEntry({
    required this.id,
    required this.degree,
    required this.institution,
    required this.year,
  });

  final String id;
  final String degree;
  final String institution;
  final int year;

  VerificationEducationEntry copyWith({
    String? degree,
    String? institution,
    int? year,
  }) =>
      VerificationEducationEntry(
        id: id,
        degree: degree ?? this.degree,
        institution: institution ?? this.institution,
        year: year ?? this.year,
      );

  factory VerificationEducationEntry.fromJson(Map<String, dynamic> json) =>
      VerificationEducationEntry(
        id: json['id'] as String,
        degree: json['degree'] as String? ?? '',
        institution: json['institution'] as String? ?? '',
        year: json['year'] as int? ?? DateTime.now().year,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'degree': degree,
        'institution': institution,
        'year': year,
      };
}
