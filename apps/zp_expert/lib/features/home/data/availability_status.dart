import 'package:flutter/foundation.dart';

@immutable
class AvailabilityStatus {
  const AvailabilityStatus({
    required this.isOnline,
    this.offlineUntil,
  });

  factory AvailabilityStatus.online() =>
      const AvailabilityStatus(isOnline: true);

  final bool isOnline;
  final DateTime? offlineUntil;

  AvailabilityStatus copyWith({
    bool? isOnline,
    DateTime? offlineUntil,
    bool clearOfflineUntil = false,
  }) {
    return AvailabilityStatus(
      isOnline: isOnline ?? this.isOnline,
      offlineUntil:
          clearOfflineUntil ? null : (offlineUntil ?? this.offlineUntil),
    );
  }
}
