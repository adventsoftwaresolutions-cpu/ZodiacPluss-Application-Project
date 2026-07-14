import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'max_attempt_exhausted_model.dart';
import 'max_attempt_exhausted_repository.dart';

final maxAttemptRepositoryProvider =
    Provider<MaxAttemptExhaustedRepository>(
  (ref) => MaxAttemptExhaustedRepository(),
);

final maxAttemptProvider =
    FutureProvider<MaxAttemptExhaustedModel>((ref) async {
  return ref.read(maxAttemptRepositoryProvider).getData();
});