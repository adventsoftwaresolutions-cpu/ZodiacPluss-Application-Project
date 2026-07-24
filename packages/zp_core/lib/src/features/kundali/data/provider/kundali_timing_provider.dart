import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/kundali_birth_data.dart';
import '../models/kundali_timing_model.dart';
import 'kundali_repository_provider.dart';

final kundaliTimingProvider =
    FutureProvider.autoDispose.family<KundaliTimingData, KundaliTimingQuery>(
  (ref, query) => ref
      .watch(kundaliRepositoryProvider)
      .getTiming(query.birthData, asOf: query.asOf),
);
