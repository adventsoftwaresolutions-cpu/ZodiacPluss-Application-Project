import '../../../../shared/constants/app_assets.dart';
import '../models/expert_profile_model.dart';

abstract class ExpertProfilePageRepository {
  Future<ExpertProfileModel> fetchProfile();

  Future<ProfileChangeRequest> submitChangeRequest({
    required String section,
    required Map<String, dynamic> payload,
  });
}

class StubExpertProfilePageRepository implements ExpertProfilePageRepository {
  static final List<ProfileChangeRequest> _requests = <ProfileChangeRequest>[];

  @override
  Future<ExpertProfileModel> fetchProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 550));
    return const ExpertProfileModel(
      name: 'Shreya',
      role: 'Psychologist',
      avatarPath: AppAssets.clientAvatarOne,
      isVerified: true,
      isOnline: true,
      about:
          'I am a licensed psychologist with 8+ years of experience helping individuals overcome anxiety, stress and relationship challenges and on personal growth challenges.',
      yearsExperience: 8,
      education: <EducationEntry>[
        EducationEntry(
          degree: 'Ph.D. in Clinical Psychology',
          institution: 'Delhi University',
          year: 2016,
        ),
        EducationEntry(
          degree: 'M.Phil in Psychology',
          institution: 'Delhi University',
          year: 2012,
        ),
      ],
      specializations: <String>[
        'Stress Management',
        'Depression',
        'Self Esteem',
        'Anxiety',
        'Relationships',
        'Trauma Recovery',
      ],
      introUploaded: true,
      mediaCount: 8,
      consultationRates: <ConsultationRate>[
        ConsultationRate(type: ConsultationType.video, ratePerMinute: 50),
        ConsultationRate(type: ConsultationType.voice, ratePerMinute: 40),
        ConsultationRate(type: ConsultationType.chat, ratePerMinute: 30),
      ],
    );
  }

  @override
  Future<ProfileChangeRequest> submitChangeRequest({
    required String section,
    required Map<String, dynamic> payload,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final ProfileChangeRequest request = ProfileChangeRequest(
      id: 'request-${_requests.length + 1}',
      section: section,
      payload: payload,
      submittedAt: DateTime.now(),
    );
    _requests.add(request);
    return request;
  }
}
