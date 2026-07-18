import 'package:flutter/foundation.dart';

@immutable
class AvailabilityStatus {
  const AvailabilityStatus({
    required this.isOnline,
    this.offlineUntil,
    this.isUpdating = false,
    this.errorMessage,
  });

  factory AvailabilityStatus.offline() =>
      const AvailabilityStatus(isOnline: false);

  factory AvailabilityStatus.online() =>
      const AvailabilityStatus(isOnline: true);

  final bool isOnline;
  final DateTime? offlineUntil;
  final bool isUpdating;
  final String? errorMessage;

  AvailabilityStatus copyWith({
    bool? isOnline,
    DateTime? offlineUntil,
    bool clearOfflineUntil = false,
    bool? isUpdating,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AvailabilityStatus(
      isOnline: isOnline ?? this.isOnline,
      offlineUntil:
          clearOfflineUntil ? null : (offlineUntil ?? this.offlineUntil),
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
