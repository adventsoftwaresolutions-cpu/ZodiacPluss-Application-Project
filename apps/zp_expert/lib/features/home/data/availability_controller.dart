import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'availability_status.dart';

final StateNotifierProvider<AvailabilityController, AvailabilityStatus>
    availabilityControllerProvider =
    StateNotifierProvider<AvailabilityController, AvailabilityStatus>(
  (Ref ref) => AvailabilityController(),
);

class AvailabilityController extends StateNotifier<AvailabilityStatus> {
  AvailabilityController() : super(AvailabilityStatus.online());

  /// TODO: replace with real repo call (API/local persistence) once backend
  /// contract for expert availability is defined.
  Future<void> goOnline() async {
    state = state.copyWith(isOnline: true, clearOfflineUntil: true);
  }

  Future<void> goOffline(DateTime returnTime) async {
    state = state.copyWith(isOnline: false, offlineUntil: returnTime);
  }
}