import 'verification_failed_model.dart';

class VerificationFailedRepository {
  Future<VerificationFailedModel> getVerificationData() async {
    return const VerificationFailedModel(
      title: 'Verification Failed!',
      description:
          'We are sorry! Your information could not be verified automatically. Our team is now reviewing your details.',
    );
  }
}