import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'availability_repository.dart';
import 'availability_status.dart';

final StateNotifierProvider<AvailabilityController, AvailabilityStatus>
    availabilityControllerProvider =
    StateNotifierProvider<AvailabilityController, AvailabilityStatus>(
  (Ref ref) {
    final AvailabilityController controller = AvailabilityController(
      ref.watch(availabilityRepositoryProvider),
    );
    controller.initializeOffline();
    return controller;
  },
);

class AvailabilityController extends StateNotifier<AvailabilityStatus> {
  AvailabilityController(this._repository)
      : super(AvailabilityStatus.offline());

  final AvailabilityRepository _repository;

  Future<void> initializeOffline() async {
    state = state.copyWith(isOnline: false, isUpdating: true, clearError: true);
    try {
      await _repository.setAvailability(online: false);
      state = state.copyWith(isOnline: false, isUpdating: false);
    } catch (error) {
      state = state.copyWith(
        isOnline: false,
        isUpdating: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> goOnline() => _setAvailability(online: true);

  Future<void> goOffline(DateTime returnTime) => _setAvailability(
        online: false,
        offlineUntil: returnTime,
      );

  Future<void> _setAvailability({
    required bool online,
    DateTime? offlineUntil,
  }) async {
    if (state.isUpdating || state.isOnline == online) return;
    state = state.copyWith(isUpdating: true, clearError: true);
    try {
      await _repository.setAvailability(online: online);
      state = state.copyWith(
        isOnline: online,
        offlineUntil: offlineUntil,
        clearOfflineUntil: online,
        isUpdating: false,
      );
    } catch (error) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }
}
