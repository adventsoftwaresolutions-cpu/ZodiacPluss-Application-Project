import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/kundali_timing_model.dart';
import '../repository/kundali_timing_repository.dart';

final kundaliTimingRepositoryProvider = Provider<KundaliTimingRepository>(
  (ref) => const StubKundaliTimingRepository(),
);

final kundaliTimingProvider = FutureProvider.autoDispose<KundaliTimingData>(
  (ref) => ref.watch(kundaliTimingRepositoryProvider).getTiming(),
);
