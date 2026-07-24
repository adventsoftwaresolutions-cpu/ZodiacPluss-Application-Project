import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/verification/data/models/verification_form_model.dart';
import 'package:zp_expert/features/verification/data/provider/verification_form_provider.dart';
import 'package:zp_expert/features/verification/data/repository/verification_repository.dart';
import 'package:zp_expert/shared/data/expert_profile.dart';
import 'package:zp_expert/shared/data/expert_identity.dart';
import 'package:zp_expert/shared/data/expert_profile_repository.dart';
import 'package:zp_expert/shared/constants/app_assets.dart';

void main() {
  test('complete verification form is submitted through its repository',
      () async {
    final _RecordingVerificationRepository repository =
        _RecordingVerificationRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        verificationRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final VerificationFormController controller =
        container.read(verificationFormProvider.notifier);
    controller.updateBasicInfo(
      fullName: 'Dr. Priya Sharma',
      email: 'priya@example.com',
      address: 'Mumbai',
      gender: 'Female',
      dateOfBirth: DateTime(1992, 4, 12),
    );
    controller.toggleLanguage('English');
    controller.setProfilePhoto('Gallery photo');
    controller.setProfession(ExpertRole.psychologist);
    controller.updateProfessionalInfo(
      availability: 'Full Time',
    );
    controller.setOtherPlatform(false);
    controller.setDailyContributionHours(6);
    controller.setYearsExperience(8);
    controller.addEducation();

    final VerificationEducationEntry blankEntry =
        container.read(verificationFormProvider).form.education.single;
    controller.updateEducation(blankEntry.copyWith(
      degree: 'M.Sc. Psychology',
      institution: 'University of Mumbai',
      year: 2018,
    ));
    controller.toggleSpecialization('Anxiety');
    controller.setQualification('masters-degree.pdf');

    expect(await controller.submit(), isTrue);
    expect(repository.submission?.fullName, 'Dr. Priya Sharma');
    expect(repository.submission?.education.single.degree, 'M.Sc. Psychology');
    expect(repository.submission?.specializations, contains('Anxiety'));
    expect(container.read(verificationFormProvider).isSubmitted, isTrue);
  });

  test('astrologer can submit without education or qualification', () async {
    final _RecordingVerificationRepository repository =
        _RecordingVerificationRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        verificationRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final VerificationFormController controller =
        container.read(verificationFormProvider.notifier);
    controller.updateBasicInfo(
      fullName: 'Arjun Mehta',
      email: 'arjun@example.com',
      address: 'Jaipur',
      gender: 'Male',
      dateOfBirth: DateTime(1988, 8, 20),
    );
    controller.toggleLanguage('Hindi');
    controller.setProfilePhoto('Camera photo');
    controller.setProfession(ExpertRole.astrologer);
    controller.updateProfessionalInfo(availability: 'Part Time');
    controller.setOtherPlatform(true);
    controller.setOtherPlatformName('Astro Platform');
    controller.setDailyContributionHours(4);
    controller.setYearsExperience(10);
    controller.setAstrologyLearningSource('Studied under a family guru');
    controller.toggleSpecialization('Vedic Astrology');

    expect(await controller.submit(), isTrue);
    expect(repository.submission?.profession, ExpertRole.astrologer);
    expect(repository.submission?.education, isEmpty);
    expect(repository.submission?.qualificationFileName, isNull);
    expect(
      repository.submission?.specializations,
      contains('Vedic Astrology'),
    );
    final ExpertProfile temporaryProfile =
        await container.read(expertProfileRepositoryProvider).fetchProfile();
    expect(temporaryProfile.name, 'Arjun Mehta');
    expect(temporaryProfile.role, ExpertRole.astrologer);
    expect(temporaryProfile.avatarUrl, 'Camera photo');
    expect(temporaryProfile.yearsExperience, 10);
  });

  test('discarding a verification draft preserves shared fallback profile',
      () async {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);
    final VerificationFormController controller =
        container.read(verificationFormProvider.notifier);

    controller.updateBasicInfo(fullName: 'Temporary Expert');
    controller.setProfilePhoto('/tmp/temporary-profile.jpg');
    await controller.discardDraftProfile();

    final ExpertProfile profile =
        await container.read(expertProfileRepositoryProvider).fetchProfile();
    expect(profile.name, defaultExpertDisplayName);
    expect(profile.avatarUrl, AppAssets.expertAvatar);
  });

  test('incomplete verification form is not sent to the repository', () async {
    final _RecordingVerificationRepository repository =
        _RecordingVerificationRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        verificationRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final bool submitted =
        await container.read(verificationFormProvider.notifier).submit();

    expect(submitted, isFalse);
    expect(repository.submission, isNull);
    expect(
      container.read(verificationFormProvider).validationMessage,
      isNotNull,
    );
  });
}

class _RecordingVerificationRepository implements VerificationRepository {
  VerificationFormModel? submission;

  @override
  Future<void> submitVerification(VerificationFormModel form) async {
    submission = form;
  }
}
