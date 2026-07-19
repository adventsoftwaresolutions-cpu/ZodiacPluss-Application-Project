import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/expert_session_repository.dart';
import '../../../shared/network/expert_api_client.dart';

abstract class AvailabilityRepository {
  Future<void> setAvailability({required bool online});
}

class ApiAvailabilityRepository implements AvailabilityRepository {
  const ApiAvailabilityRepository({
    required ExpertApiClient api,
    required ExpertSessionRepository sessions,
  })  : _api = api,
        _sessions = sessions;

  final ExpertApiClient _api;
  final ExpertSessionRepository _sessions;

  @override
  Future<void> setAvailability({required bool online}) {
    return _sessions.authenticated<void>((String accessToken) async {
      await _api.patch(
        '/api/v1/experts/me/availability',
        accessToken: accessToken,
        body: <String, dynamic>{'online': online},
      );
    });
  }
}

final Provider<AvailabilityRepository> availabilityRepositoryProvider =
    Provider<AvailabilityRepository>((Ref ref) {
  return ApiAvailabilityRepository(
    api: ref.watch(expertApiClientProvider),
    sessions: ref.watch(expertSessionRepositoryProvider),
  );
});
