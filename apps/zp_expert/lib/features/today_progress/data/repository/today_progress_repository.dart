import '../models/today_progress_model.dart';
import '../../../../shared/dev/stimulated_latency.dart';

abstract class TodayProgressRepository {
  Future<TodayProgressData> fetchTodayProgress();
}

class StubTodayProgressRepository implements TodayProgressRepository {
  @override
  Future<TodayProgressData> fetchTodayProgress() async {
    await simulateNetworkLatency();
    return const TodayProgressData(
      overview: OverviewData(
        earningsToday: 5840.00,
        sessionsCompleted: 18,
        consultationTime: Duration(hours: 4, minutes: 35),
        clientsServed: 14,
      ),
      sessionStatus: SessionStatusData(
        completed: 12,
        upcoming: 4,
        active: 1,
        cancelledByClient: 2,
        cancelledByExpert: 0,
        missed: 1,
      ),
      consultation: ConsultationData(
        chat: 8,
        voice: 6,
        video: 4,
      ),
      timeAvailability: TimeAvailabilityData(
        onlineTime: Duration(hours: 6, minutes: 20),
        busyTime: Duration(hours: 4, minutes: 35),
        availableTime: Duration(hours: 1, minutes: 45),
        avgResponseTime: Duration(minutes: 2, seconds: 25),
      ),
      clientEngagement: ClientEngagementData(
        newClients: 5,
        returningClients: 7,
        loyalClients: 2,
        avgRatingToday: 4.8,
      ),
    );
  }
}
