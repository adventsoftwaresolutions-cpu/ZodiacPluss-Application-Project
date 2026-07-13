import 'verification_pending_model.dart';

class VerificationPendingRepository {
  Future<VerificationPendingModel> getVerificationStatus() async {
    // Local data for now.
    // Later this will become an API call.

    return const VerificationPendingModel(
      isVerified: false,
      title: "Verification in Progress",
      description:
          "Thank you! Your information has been submitted successfully. Our team is reviewing your details.",
    );
  }
}