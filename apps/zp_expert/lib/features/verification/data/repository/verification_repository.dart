import '../models/verification_form_model.dart';

abstract class VerificationRepository {
  Future<void> submitVerification(VerificationFormModel form);
}

class StubVerificationRepository implements VerificationRepository {
  VerificationFormModel? _lastSubmission;

  VerificationFormModel? get lastSubmission => _lastSubmission;

  @override
  Future<void> submitVerification(VerificationFormModel form) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    _lastSubmission = VerificationFormModel.fromJson(form.toJson());
  }
}
