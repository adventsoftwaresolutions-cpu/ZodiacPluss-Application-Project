import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/expert_profile.dart';
import '../models/verification_form_model.dart';
import '../repository/verification_repository.dart';

final Provider<VerificationRepository> verificationRepositoryProvider =
    Provider<VerificationRepository>(
  (Ref ref) => StubVerificationRepository(),
);

final NotifierProvider<VerificationFormController, VerificationFormState>
    verificationFormProvider =
    NotifierProvider<VerificationFormController, VerificationFormState>(
  VerificationFormController.new,
);

class VerificationFormState {
  const VerificationFormState({
    required this.form,
    required this.isSubmitting,
    required this.isSubmitted,
    required this.validationMessage,
    required this.currentStep,
  });

  factory VerificationFormState.initial() => VerificationFormState(
        form: VerificationFormModel.initial(),
        isSubmitting: false,
        isSubmitted: false,
        validationMessage: null,
        currentStep: 0,
      );

  final VerificationFormModel form;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? validationMessage;
  final int currentStep;

  VerificationFormState copyWith({
    VerificationFormModel? form,
    bool? isSubmitting,
    bool? isSubmitted,
    String? validationMessage,
    int? currentStep,
    bool clearValidationMessage = false,
  }) =>
      VerificationFormState(
        form: form ?? this.form,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSubmitted: isSubmitted ?? this.isSubmitted,
        validationMessage: clearValidationMessage
            ? null
            : validationMessage ?? this.validationMessage,
        currentStep: currentStep ?? this.currentStep,
      );
}

class VerificationFormController extends Notifier<VerificationFormState> {
  int _educationSequence = 0;

  @override
  VerificationFormState build() => VerificationFormState.initial();

  void updateBasicInfo({
    String? fullName,
    String? email,
    String? address,
    String? gender,
    DateTime? dateOfBirth,
  }) {
    _setForm(state.form.copyWith(
      fullName: fullName,
      email: email,
      address: address,
      gender: gender,
      dateOfBirth: dateOfBirth,
    ));
  }

  void toggleLanguage(String language) {
    final Set<String> selected = state.form.languages.toSet();
    selected.contains(language)
        ? selected.remove(language)
        : selected.add(language);
    _setForm(state.form.copyWith(languages: selected.toList()));
  }

  void updateProfessionalInfo({
    ExpertRole? profession,
    String? availability,
  }) {
    _setForm(state.form.copyWith(
      profession: profession,
      availability: availability,
    ));
  }

  void setProfession(ExpertRole profession) {
    if (profession == state.form.profession) return;
    _setForm(state.form.copyWith(
      profession: profession,
      specializations: <String>[],
    ));
  }

  void setOtherPlatform(bool value) {
    _setForm(state.form.copyWith(
      worksOnOtherPlatform: value,
      otherPlatformName: value ? state.form.otherPlatformName : '',
    ));
  }

  void setOtherPlatformName(String value) {
    _setForm(state.form.copyWith(otherPlatformName: value));
  }

  void setDailyContributionHours(int hours) {
    _setForm(state.form.copyWith(
      dailyContributionHours: hours.clamp(0, 16),
    ));
  }

  void setYearsExperience(int years) {
    _setForm(state.form.copyWith(yearsExperience: years.clamp(0, 60)));
  }

  void addEducation() {
    _educationSequence++;
    final VerificationEducationEntry entry = VerificationEducationEntry(
      id: 'education-${DateTime.now().microsecondsSinceEpoch}-$_educationSequence',
      degree: '',
      institution: '',
      year: DateTime.now().year,
    );
    _setForm(state.form.copyWith(
      education: <VerificationEducationEntry>[...state.form.education, entry],
    ));
  }

  void updateEducation(VerificationEducationEntry updated) {
    _setForm(state.form.copyWith(
      education: state.form.education
          .map((VerificationEducationEntry item) =>
              item.id == updated.id ? updated : item)
          .toList(),
    ));
  }

  void removeEducation(String id) {
    _setForm(state.form.copyWith(
      education: state.form.education
          .where((VerificationEducationEntry item) => item.id != id)
          .toList(),
    ));
  }

  void toggleSpecialization(String specialization) {
    final Set<String> selected = state.form.specializations.toSet();
    selected.contains(specialization)
        ? selected.remove(specialization)
        : selected.add(specialization);
    _setForm(state.form.copyWith(specializations: selected.toList()));
  }

  void setAstrologyLearningSource(String value) {
    _setForm(state.form.copyWith(astrologyLearningSource: value));
  }

  void setQualification(String fileName) {
    _setForm(state.form.copyWith(qualificationFileName: fileName));
  }

  void removeQualification() {
    _setForm(state.form.copyWith(clearQualification: true));
  }

  void setProfilePhoto(String source) {
    _setForm(state.form.copyWith(profilePhotoSource: source));
  }

  void removeProfilePhoto() {
    _setForm(state.form.copyWith(clearProfilePhoto: true));
  }

  bool validateStep(int step) {
    final String? validationMessage = _validateStep(state.form, step);
    if (validationMessage != null) {
      state = state.copyWith(validationMessage: validationMessage);
      return false;
    }
    state = state.copyWith(clearValidationMessage: true);
    return true;
  }

  void goToStep(int step) {
    state = state.copyWith(
      currentStep: step.clamp(0, 3),
      clearValidationMessage: true,
    );
  }

  Future<bool> submit() async {
    final String? validationMessage = _validate(state.form);
    if (validationMessage != null) {
      state = state.copyWith(validationMessage: validationMessage);
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      isSubmitted: false,
      clearValidationMessage: true,
    );
    try {
      await ref
          .read(verificationRepositoryProvider)
          .submitVerification(state.form);
      state = state.copyWith(isSubmitting: false, isSubmitted: true);
      return true;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        validationMessage: 'Unable to submit verification. Please try again.',
      );
      return false;
    }
  }

  void _setForm(VerificationFormModel form) {
    state = state.copyWith(
      form: form,
      isSubmitted: false,
      clearValidationMessage: true,
    );
  }

  String? _validate(VerificationFormModel form) {
    for (int step = 0; step < 3; step++) {
      final String? message = _validateStep(form, step);
      if (message != null) return message;
    }
    return null;
  }

  String? _validateStep(VerificationFormModel form, int step) {
    if (step == 0) return _validatePersonalDetails(form);
    if (step == 1) return _validateWorkDetails(form);
    if (step == 2) return _validateExpertise(form);
    return null;
  }

  String? _validatePersonalDetails(VerificationFormModel form) {
    if (form.fullName.trim().isEmpty ||
        form.email.trim().isEmpty ||
        form.address.trim().isEmpty) {
      return 'Complete all basic information fields.';
    }
    if (!form.email.contains('@')) return 'Enter a valid email address.';
    if (form.gender == null || form.dateOfBirth == null) {
      return 'Add your gender and date of birth.';
    }
    if (form.languages.isEmpty) return 'Select at least one language.';
    if (form.profilePhotoSource == null) return 'Select a profile photo.';
    return null;
  }

  String? _validateWorkDetails(VerificationFormModel form) {
    if (form.profession == null || form.availability == null) {
      return 'Choose your profession and availability.';
    }
    if (form.worksOnOtherPlatform == null) {
      return 'Tell us whether you work on another platform.';
    }
    if (form.worksOnOtherPlatform! && form.otherPlatformName.trim().isEmpty) {
      return 'Enter the other platform name.';
    }
    if (form.dailyContributionHours <= 0) {
      return 'Select how many hours you can contribute daily.';
    }
    return null;
  }

  String? _validateExpertise(VerificationFormModel form) {
    if (form.yearsExperience <= 0) {
      return 'Add your professional experience.';
    }
    if (form.profession == ExpertRole.psychologist) {
      if (form.education.isEmpty ||
          form.education.any((VerificationEducationEntry item) =>
              item.degree.trim().isEmpty || item.institution.trim().isEmpty)) {
        return 'Add at least one complete education entry.';
      }
      if (form.qualificationFileName == null) {
        return 'Attach a qualification document.';
      }
    }
    if (form.profession == ExpertRole.astrologer &&
        form.astrologyLearningSource.trim().isEmpty) {
      return 'Tell us where you learned astrology.';
    }
    if (form.specializations.isEmpty) {
      return 'Select at least one specialization.';
    }
    return null;
  }
}
