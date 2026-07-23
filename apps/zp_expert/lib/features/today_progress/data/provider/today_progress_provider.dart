import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/today_progress_model.dart';
import '../repository/today_progress_repository.dart';

final Provider<TodayProgressRepository> todayProgressRepositoryProvider =
    Provider<TodayProgressRepository>(
  (Ref ref) => StubTodayProgressRepository(),
);

final FutureProvider<TodayProgressData> todayProgressProvider =
    FutureProvider<TodayProgressData>((Ref ref) {
  return ref.watch(todayProgressRepositoryProvider).fetchTodayProgress();
});
