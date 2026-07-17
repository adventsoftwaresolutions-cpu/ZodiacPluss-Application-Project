import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/kundali_planet_model.dart';
import '../repository/kundali_planets_repository.dart';

final kundaliPlanetsRepositoryProvider = Provider<KundaliPlanetsRepository>(
  (ref) => const StubKundaliPlanetsRepository(),
);

final kundaliPlanetsProvider = FutureProvider.autoDispose<KundaliPlanetsData>(
  (ref) => ref.watch(kundaliPlanetsRepositoryProvider).getPlanets(),
);
