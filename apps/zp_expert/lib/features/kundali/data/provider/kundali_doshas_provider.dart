import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/kundali_dosha_model.dart';
import '../repository/kundali_doshas_repository.dart';

final kundaliDoshasRepositoryProvider = Provider<KundaliDoshasRepository>(
  (ref) => const StubKundaliDoshasRepository(),
);

final kundaliDoshasProvider = FutureProvider.autoDispose<KundaliDoshasData>(
  (ref) => ref.watch(kundaliDoshasRepositoryProvider).getDoshas(),
);
