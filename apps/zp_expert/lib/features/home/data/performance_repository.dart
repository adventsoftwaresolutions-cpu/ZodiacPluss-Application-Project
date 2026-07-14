import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/dev/stimulated_latency.dart';
import 'performance_stats.dart';

abstract class PerformanceRepository {
  Future<PerformanceStats> fetchStats();
}

/// In-memory placeholder until the Supabase/Node backend is wired in.
class MockPerformanceRepository implements PerformanceRepository {
  @override
  Future<PerformanceStats> fetchStats() async {
    await simulateNetworkLatency();
    return const PerformanceStats(
      earningsToday: 5840.00,
      averageRating: 4.8,
      responseTime: Duration(minutes: 2, seconds: 25),
      missedSessions: 12,
      cancelledSessions: 3,
    );
  }
}

final Provider<PerformanceRepository> performanceRepositoryProvider =
    Provider<PerformanceRepository>(
  (Ref ref) => MockPerformanceRepository(),
);

final FutureProvider<PerformanceStats> performanceStatsProvider =
    FutureProvider<PerformanceStats>((Ref ref) {
  return ref.watch(performanceRepositoryProvider).fetchStats();
});