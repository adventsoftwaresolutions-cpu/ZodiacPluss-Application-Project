import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/overall_performance_model.dart';
import '../repository/overall_performance_repository.dart';

final Provider<OverallPerformanceRepository>
    overallPerformanceRepositoryProvider =
    Provider<OverallPerformanceRepository>(
  (Ref ref) => StubOverallPerformanceRepository(),
);

final FutureProvider<PerformanceMetrics> lifetimePerformanceProvider =
    FutureProvider<PerformanceMetrics>((Ref ref) {
  return ref
      .watch(overallPerformanceRepositoryProvider)
      .fetchLifetimePerformance();
});

final FutureProviderFamily<PerformanceMetrics, String>
    periodPerformanceProvider =
    FutureProvider.family<PerformanceMetrics, String>(
        (Ref ref, String periodKey) {
  return ref
      .watch(overallPerformanceRepositoryProvider)
      .fetchPeriodPerformance(periodKey);
});
