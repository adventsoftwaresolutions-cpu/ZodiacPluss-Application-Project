import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dev/stimulated_latency.dart';
import 'expert_profile.dart';

abstract class ExpertProfileRepository {
  Future<ExpertProfile> fetchProfile();
}

/// In-memory placeholder until the auth/profile endpoint exists.
/// Flip `role` to ExpertRole.astrologer here to test the Queue
/// variant end-to-end without touching any other file.
class MockExpertProfileRepository implements ExpertProfileRepository {
  @override
  Future<ExpertProfile> fetchProfile() async {
    await simulateNetworkLatency();
    return const ExpertProfile(
      id: 'expert_001',
      name: 'Shreya',
      role: ExpertRole.psychologist,
      avatarUrl: 'assets/images/dp.jpg',
      isVerified: true,
    );
  }
}

final Provider<ExpertProfileRepository> expertProfileRepositoryProvider =
    Provider<ExpertProfileRepository>(
  (Ref ref) => MockExpertProfileRepository(),
);

final FutureProvider<ExpertProfile> expertProfileProvider =
    FutureProvider<ExpertProfile>((Ref ref) {
  return ref.watch(expertProfileRepositoryProvider).fetchProfile();
});