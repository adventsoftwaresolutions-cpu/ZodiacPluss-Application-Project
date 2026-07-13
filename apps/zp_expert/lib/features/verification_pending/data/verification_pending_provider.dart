import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'verification_pending_model.dart';
import 'verification_pending_repository.dart';

final verificationRepositoryProvider =
    Provider<VerificationPendingRepository>((ref) {
  return VerificationPendingRepository();
});

final verificationProvider =
    FutureProvider<VerificationPendingModel>((ref) async {
  final repository = ref.read(verificationRepositoryProvider);

  return repository.getVerificationStatus();
});