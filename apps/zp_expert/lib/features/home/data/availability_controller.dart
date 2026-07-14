import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/dev/stimulated_latency.dart';
import 'availability_repository.dart';
import 'availability_status.dart';

final StateNotifierProvider<AvailabilityController, AvailabilityStatus>
    availabilityControllerProvider =
    StateNotifierProvider<AvailabilityController, AvailabilityStatus>(
  (Ref ref) =>
      AvailabilityController(ref.watch(availabilityRepositoryProvider)),
);

class AvailabilityController extends StateNotifier<AvailabilityStatus> {
  AvailabilityController(this._repository)
      : super(AvailabilityStatus.online());

  final AvailabilityRepository _repository;

  Future<void> goOnline() async {
    await simulateNetworkLatency();
    await _repository.setOnline();
    state = state.copyWith(isOnline: true, clearOfflineUntil: true);
  }

  Future<void> goOffline(DateTime returnTime) async {
    await simulateNetworkLatency();
    await _repository.setOffline(returnTime);
    state = state.copyWith(isOnline: false, offlineUntil: returnTime);
  }
}