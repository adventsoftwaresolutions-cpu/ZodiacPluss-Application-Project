import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_assets.dart';
import '../dev/stimulated_latency.dart';
import 'expert_profile.dart';

abstract class ExpertProfileRepository {
  Future<ExpertProfile> fetchProfile();
}

class StubExpertProfileRepository implements ExpertProfileRepository {
  @override
  Future<ExpertProfile> fetchProfile() async {
    await simulateNetworkLatency();
    return const ExpertProfile(
      id: 'expert_001',
      name: 'Shreya',
      role: ExpertRole.astrologer,
      avatarUrl: AppAssets.expertAvatar,
      isVerified: true,
      about:
          'I am an experienced astrologer helping people understand life patterns, relationships and personal growth through practical guidance.',
      yearsExperience: 8,
      education: <EducationEntry>[
        EducationEntry(
          degree: 'Jyotish Acharya',
          institution: 'Bharatiya Vidya Bhavan',
          year: 2016,
        ),
        EducationEntry(
          degree: 'M.A. in Astrology',
          institution: 'Sampurnanand Sanskrit University',
          year: 2012,
        ),
      ],
      specializations: <String>[
        'Vedic Astrology',
        'Kundali Analysis',
        'Relationships',
        'Career Guidance',
        'Marriage Matching',
        'Planetary Transits',
      ],
      introUploaded: true,
      mediaCount: 8,
      consultationRates: <ConsultationRate>[
        ConsultationRate(type: ConsultationType.video, ratePerMinute: 60),
        ConsultationRate(type: ConsultationType.voice, ratePerMinute: 60),
        ConsultationRate(type: ConsultationType.chat, ratePerMinute: 30),
      ],
    );
  }
}

final Provider<ExpertProfileRepository> expertProfileRepositoryProvider =
    Provider<ExpertProfileRepository>(
  (Ref ref) => StubExpertProfileRepository(),
);

final FutureProvider<ExpertProfile> expertProfileProvider =
    FutureProvider<ExpertProfile>((Ref ref) {
  return ref.watch(expertProfileRepositoryProvider).fetchProfile();
});
