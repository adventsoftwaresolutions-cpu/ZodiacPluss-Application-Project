import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/expert_profile.dart';
import '../../../shared/data/expert_profile_repository.dart';
import 'appointment_repository.dart';
import 'queue_repository.dart';
import 'schedule_models.dart';

final FutureProvider<ScheduleViewData> scheduleViewDataProvider =
    FutureProvider<ScheduleViewData>((Ref ref) async {
  final ExpertProfile profile = await ref.watch(expertProfileProvider.future);

  if (profile.role == ExpertRole.astrologer) {
    final List<QueueEntry> queue =
        await ref.watch(queueRepositoryProvider).fetchQueue();
    return QueueScheduleData(queue);
  }

  final List<AppointmentEntry> appointments =
      await ref.watch(appointmentRepositoryProvider).fetchUpcoming();
  return AppointmentScheduleData(appointments);
});

final StateNotifierProvider<ScheduleActionsController, AsyncValue<void>>
    scheduleActionsControllerProvider =
    StateNotifierProvider<ScheduleActionsController, AsyncValue<void>>(
  (Ref ref) => ScheduleActionsController(ref),
);

class ScheduleActionsController extends StateNotifier<AsyncValue<void>> {
  ScheduleActionsController(this._ref)
      : super(const AsyncValue<void>.data(null));

  final Ref _ref;

  Future<void> cancelAppointment(String appointmentId) async {
    state = const AsyncValue<void>.loading();
    try {
      await _ref.read(appointmentRepositoryProvider).cancel(appointmentId);
      _ref.invalidate(scheduleViewDataProvider); // single source of truth
      state = const AsyncValue<void>.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue<void>.error(error, stackTrace);
    }
  }
}