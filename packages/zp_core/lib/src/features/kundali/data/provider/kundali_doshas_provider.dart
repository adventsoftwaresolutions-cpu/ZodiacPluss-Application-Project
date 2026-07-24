import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/kundali_birth_data.dart';
import '../models/kundali_dosha_model.dart';
import 'kundali_repository_provider.dart';

final kundaliDoshasProvider =
    FutureProvider.autoDispose.family<KundaliDoshasData, KundaliBirthData>(
  (ref, birthData) => ref.watch(kundaliRepositoryProvider).getDoshas(birthData),
);
