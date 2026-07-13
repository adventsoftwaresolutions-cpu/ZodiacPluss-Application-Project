import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'verification_failed_model.dart';
import 'verification_failed_repository.dart';

final verificationFailedRepositoryProvider =
    Provider<VerificationFailedRepository>(
  (ref) => VerificationFailedRepository(),
);

final verificationFailedProvider =
    FutureProvider<VerificationFailedModel>((ref) async {
  return ref
      .read(verificationFailedRepositoryProvider)
      .getVerificationData();
});