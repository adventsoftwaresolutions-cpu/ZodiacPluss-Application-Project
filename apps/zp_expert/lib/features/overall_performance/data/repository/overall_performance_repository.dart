import '../models/overall_performance_model.dart';
import '../../../../shared/dev/stimulated_latency.dart';

abstract class OverallPerformanceRepository {
  Future<PerformanceMetrics> fetchLifetimePerformance();
  Future<PerformanceMetrics> fetchPeriodPerformance(String periodKey);
}

class StubOverallPerformanceRepository
    implements OverallPerformanceRepository {
  @override
  Future<PerformanceMetrics> fetchLifetimePerformance() async {
    await simulateNetworkLatency();
    return const PerformanceMetrics(
      totalEarning: 284500.00,
      totalSessionsCompleted: 1247,
      totalConsultationTime: Duration(hours: 832, minutes: 15),
      totalClientsServed: 463,
      cancelledByClient: 38,
      cancelledByExpert: 7,
      missed: 12,
      totalOnlineTime: Duration(hours: 1640),
      totalBusyTime: Duration(hours: 832, minutes: 15),
      avgResponseTime: Duration(minutes: 2, seconds: 18),
    );
  }

  @override
  Future<PerformanceMetrics> fetchPeriodPerformance(String periodKey) async {
    await simulateNetworkLatency();
    // Varied stub data so different periods look distinct.
    final int hash = periodKey.hashCode.abs();
    final bool isMonthly = periodKey.length == 7; // "2026-07"

    if (isMonthly) {
      return PerformanceMetrics(
        totalEarning: 18000 + (hash % 12000).toDouble(),
        totalSessionsCompleted: 60 + hash % 45,
        totalConsultationTime: Duration(hours: 38 + hash % 20, minutes: 30),
        totalClientsServed: 25 + hash % 20,
        cancelledByClient: 2 + hash % 5,
        cancelledByExpert: hash % 3,
        missed: hash % 4,
        totalOnlineTime: Duration(hours: 80 + hash % 40),
        totalBusyTime: Duration(hours: 38 + hash % 20, minutes: 30),
        avgResponseTime: Duration(minutes: 1 + hash % 3, seconds: hash % 50),
      );
    }

    return PerformanceMetrics(
      totalEarning: 2800 + (hash % 4000).toDouble(),
      totalSessionsCompleted: 8 + hash % 14,
      totalConsultationTime: Duration(hours: 3 + hash % 4, minutes: 20),
      totalClientsServed: 5 + hash % 10,
      cancelledByClient: hash % 3,
      cancelledByExpert: hash % 2,
      missed: hash % 2,
      totalOnlineTime: Duration(hours: 5 + hash % 4),
      totalBusyTime: Duration(hours: 3 + hash % 4, minutes: 20),
      avgResponseTime: Duration(minutes: 1 + hash % 4, seconds: hash % 45),
    );
  }
}
