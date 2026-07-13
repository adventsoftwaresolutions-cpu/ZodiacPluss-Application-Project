import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'weekly_availability.dart';
import 'weekly_availability_repository.dart';

final StateNotifierProvider<WeeklyAvailabilityController,
    AsyncValue<WeeklyAvailability>> weeklyAvailabilityControllerProvider =
    StateNotifierProvider<WeeklyAvailabilityController,
        AsyncValue<WeeklyAvailability>>(
  (Ref ref) => WeeklyAvailabilityController(
    ref.watch(weeklyAvailabilityRepositoryProvider),
  ),
);

class WeeklyAvailabilityController
    extends StateNotifier<AsyncValue<WeeklyAvailability>> {
  WeeklyAvailabilityController(this._repository)
      : super(const AsyncValue<WeeklyAvailability>.loading()) {
    _load();
  }

  final WeeklyAvailabilityRepository _repository;

  Future<void> _load() async {
    state = const AsyncValue<WeeklyAvailability>.loading();
    try {
      final WeeklyAvailability schedule = await _repository.fetch();
      state = AsyncValue<WeeklyAvailability>.data(schedule);
    } catch (error, stackTrace) {
      state = AsyncValue<WeeklyAvailability>.error(error, stackTrace);
    }
  }

  void toggleDay(Weekday weekday, bool isEnabled) {
    final WeeklyAvailability? current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncValue<WeeklyAvailability>.data(
      current.updateDay(
        weekday,
        (DaySchedule d) => d.copyWith(isEnabled: isEnabled),
      ),
    );
  }

  void updateFrom(Weekday weekday, AvailabilityTime time) {
    final WeeklyAvailability? current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncValue<WeeklyAvailability>.data(
      current.updateDay(weekday, (DaySchedule d) => d.copyWith(from: time)),
    );
  }

  void updateTo(Weekday weekday, AvailabilityTime time) {
    final WeeklyAvailability? current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncValue<WeeklyAvailability>.data(
      current.updateDay(weekday, (DaySchedule d) => d.copyWith(to: time)),
    );
  }

  /// Returns true on success so the widget can show a confirmation
  /// without the controller reaching into UI concerns (SnackBars, etc).
  Future<bool> save() async {
    final WeeklyAvailability? current = state.valueOrNull;
    if (current == null) {
      return false;
    }
    try {
      await _repository.update(current);
      return true;
    } catch (_) {
      return false;
    }
  }
}