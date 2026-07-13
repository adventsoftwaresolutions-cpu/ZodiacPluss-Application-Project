import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'availability_status.dart';

abstract class AvailabilityRepository {
  Future<AvailabilityStatus> fetchStatus();
  Future<void> setOnline();
  Future<void> setOffline(DateTime returnTime);
}

/// In-memory placeholder. Swap this out for a Supabase/Node-backed
/// implementation later — nothing outside this file needs to change
/// when that happens, since AvailabilityController only depends on
/// the abstract AvailabilityRepository contract.
class MockAvailabilityRepository implements AvailabilityRepository {
  AvailabilityStatus _status = AvailabilityStatus.online();

  @override
  Future<AvailabilityStatus> fetchStatus() async => _status;

  @override
  Future<void> setOnline() async {
    _status = _status.copyWith(isOnline: true, clearOfflineUntil: true);
  }

  @override
  Future<void> setOffline(DateTime returnTime) async {
    _status = AvailabilityStatus(isOnline: false, offlineUntil: returnTime);
  }
}

final Provider<AvailabilityRepository> availabilityRepositoryProvider =
    Provider<AvailabilityRepository>(
  (Ref ref) => MockAvailabilityRepository(),
);