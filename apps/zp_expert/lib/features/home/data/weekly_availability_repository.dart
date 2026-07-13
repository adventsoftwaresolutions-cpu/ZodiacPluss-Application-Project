import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'weekly_availability.dart';

abstract class WeeklyAvailabilityRepository {
  Future<WeeklyAvailability> fetch();
  Future<void> update(WeeklyAvailability schedule);
}

/// In-memory placeholder. Swap for Supabase later — the JSON-shaped
/// toJson()/fromJson() on the models already match what a `jsonb`
/// column or REST payload would expect, so this swap should only
/// touch this file.
class MockWeeklyAvailabilityRepository implements WeeklyAvailabilityRepository {
  WeeklyAvailability _schedule = WeeklyAvailability.defaultSchedule();

  @override
  Future<WeeklyAvailability> fetch() async => _schedule;

  @override
  Future<void> update(WeeklyAvailability schedule) async {
    _schedule = schedule;
  }
}

final Provider<WeeklyAvailabilityRepository> weeklyAvailabilityRepositoryProvider =
    Provider<WeeklyAvailabilityRepository>(
  (Ref ref) => MockWeeklyAvailabilityRepository(),
);