import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/kundali_repository.dart';

/// Override this provider to switch all Kundali data from the local stub to an
/// API adapter or a Swiss Ephemeris SDK adapter.
final Provider<KundaliRepository> kundaliRepositoryProvider =
    Provider<KundaliRepository>(
  (Ref ref) => const StubKundaliRepository(),
);
