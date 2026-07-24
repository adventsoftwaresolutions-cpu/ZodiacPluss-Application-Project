import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_assets.dart';
import '../dev/stimulated_latency.dart';
import 'expert_identity.dart';
import 'expert_profile.dart';

abstract class ExpertProfileRepository {
  Future<ExpertProfile> fetchProfile();
  Future<void> saveDraftProfile({
    String? name,
    ExpertRole? role,
    String? avatarUrl,
    int? yearsExperience,
    List<EducationEntry>? education,
    List<String>? specializations,
  });
  Future<void> activateDraftProfile();
  Future<void> discardDraftProfile();
  Future<void> clearDraftProfilePhoto();
}

class StubExpertProfileRepository implements ExpertProfileRepository {
  ExpertProfile? _draftProfile;
  ExpertProfile? _activeTemporaryProfile;

  @override
  Future<ExpertProfile> fetchProfile() async {
    await simulateNetworkLatency();
    return _activeTemporaryProfile ?? _defaultProfile;
  }

  @override
  Future<void> saveDraftProfile({
    String? name,
    ExpertRole? role,
    String? avatarUrl,
    int? yearsExperience,
    List<EducationEntry>? education,
    List<String>? specializations,
  }) async {
    final ExpertProfile base =
        _draftProfile ?? _activeTemporaryProfile ?? _defaultProfile;
    _draftProfile = base.copyWith(
      name: name,
      role: role,
      avatarUrl: avatarUrl,
      yearsExperience: yearsExperience,
      education: education,
      specializations: specializations,
    );
  }

  @override
  Future<void> activateDraftProfile() async {
    _activeTemporaryProfile = _draftProfile;
    _draftProfile = null;
  }

  @override
  Future<void> discardDraftProfile() async {
    _draftProfile = null;
  }

  @override
  Future<void> clearDraftProfilePhoto() async {
    final ExpertProfile fallback = _activeTemporaryProfile ?? _defaultProfile;
    _draftProfile = (_draftProfile ?? fallback).copyWith(
      avatarUrl: fallback.avatarUrl,
    );
  }

  static const ExpertProfile _defaultProfile = ExpertProfile(
    id: 'expert_001',
    name: defaultExpertDisplayName,
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

final Provider<ExpertProfileRepository> expertProfileRepositoryProvider =
    Provider<ExpertProfileRepository>(
  (Ref ref) => StubExpertProfileRepository(),
);

final FutureProvider<ExpertProfile> expertProfileProvider =
    FutureProvider<ExpertProfile>(
        (Ref ref) => ref.watch(expertProfileRepositoryProvider).fetchProfile());
