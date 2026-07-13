import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'schedule_models.dart';

abstract class AppointmentRepository {
  Future<List<AppointmentEntry>> fetchUpcoming();
  Future<void> cancel(String appointmentId);
}

class MockAppointmentRepository implements AppointmentRepository {
  final List<AppointmentEntry> _appointments = <AppointmentEntry>[
    AppointmentEntry(
      id: 'a1',
      scheduledAt: DateTime(2026, 7, 1, 10, 0),
      duration: const Duration(minutes: 45),
      clientName: 'Riya',
      clientAvatarUrl: 'assets/images/riya.jpg',
      sessionType: SessionType.video,
      status: AppointmentStatus.upcoming,
    ),
    AppointmentEntry(
      id: 'a2',
      scheduledAt: DateTime(2026, 7, 2, 10, 0),
      duration: const Duration(minutes: 45),
      clientName: 'Riya',
      clientAvatarUrl: 'assets/images/riya.jpg',
      sessionType: SessionType.video,
      status: AppointmentStatus.upcoming,
    ),
    AppointmentEntry(
      id: 'a3',
      scheduledAt: DateTime(2026, 7, 5, 10, 0),
      duration: const Duration(minutes: 45),
      clientName: 'Ikcha',
      clientAvatarUrl: 'assets/images/ikcha.jpg',
      sessionType: SessionType.voice,
      status: AppointmentStatus.upcoming,
    ),
  ];

  @override
  Future<List<AppointmentEntry>> fetchUpcoming() async {
    return _appointments
        .where((AppointmentEntry a) => a.status == AppointmentStatus.upcoming)
        .toList();
  }

  @override
  Future<void> cancel(String appointmentId) async {
    final int index =
        _appointments.indexWhere((AppointmentEntry a) => a.id == appointmentId);
    if (index == -1) return;
    _appointments[index] =
        _appointments[index].copyWith(status: AppointmentStatus.cancelled);
  }
}

final Provider<AppointmentRepository> appointmentRepositoryProvider =
    Provider<AppointmentRepository>((Ref ref) => MockAppointmentRepository());