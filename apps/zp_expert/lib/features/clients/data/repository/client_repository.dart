import '../../../../shared/constants/app_assets.dart';
import '../../../../shared/dev/stimulated_latency.dart';
import '../models/client_lists.dart';
import '../models/client_history_model.dart';
import '../models/client_model.dart';

abstract class ClientRepository {
  Future<ClientLists> fetchClients();
  Future<ClientHistoryModel> fetchClientHistory(String clientId);
  Future<void> saveClientNote(String clientId, String note);
  Future<void> cancelFutureSession(String sessionId);
}

/// Temporary local source. A Supabase or Express API implementation can
/// replace this class without changing the provider or presentation layer.
class LocalClientRepository implements ClientRepository {
  final Map<String, String> _notes = <String, String>{};
  @override
  Future<ClientLists> fetchClients() async {
    await simulateNetworkLatency(duration: const Duration(milliseconds: 250));

    return const ClientLists(
      previous: <ClientModel>[
        ClientModel(
          id: 'client-riya',
          name: 'Riya Sharma',
          phoneNumber: '+91 9876543210',
          sessionLabel: 'Last session: Monday, 10:30 AM',
          avatarAsset: AppAssets.clientAvatarOne,
          schedule: ClientSchedule.previous,
        ),
        ClientModel(
          id: 'client-sia',
          name: 'Sia Kumari',
          phoneNumber: '+91 9876543210',
          sessionLabel: 'Last session: Monday, 10:30 AM',
          avatarAsset: AppAssets.clientAvatarTwo,
          schedule: ClientSchedule.previous,
        ),
        ClientModel(
          id: 'client-vartika-previous',
          name: 'Vartika Kaur',
          phoneNumber: '+91 9876543210',
          sessionLabel: 'Last session: Monday, 10:30 AM',
          avatarAsset: AppAssets.clientAvatarThree,
          schedule: ClientSchedule.previous,
        ),
        ClientModel(
          id: 'client-ananya',
          name: 'Ananya Mehta',
          phoneNumber: '+91 9876543210',
          sessionLabel: 'Last session: Sunday, 6:00 PM',
          avatarAsset: AppAssets.clientAvatarTwo,
          schedule: ClientSchedule.previous,
        ),
        ClientModel(
          id: 'client-naina',
          name: 'Naina Kapoor',
          phoneNumber: '+91 9876543210',
          sessionLabel: 'Last session: Saturday, 4:30 PM',
          avatarAsset: AppAssets.clientAvatarThree,
          schedule: ClientSchedule.previous,
        ),
      ],
      future: <ClientModel>[
        ClientModel(
          id: 'client-kriti',
          name: 'Kriti',
          phoneNumber: '+91 9876543210',
          sessionLabel: 'Last session: Monday, 10:30 AM',
          avatarAsset: AppAssets.clientAvatarTwo,
          schedule: ClientSchedule.future,
        ),
        ClientModel(
          id: 'client-riya-future',
          name: 'Riya Sharma',
          phoneNumber: '+91 9876543210',
          sessionLabel: 'Last session: Monday, 10:30 AM',
          avatarAsset: AppAssets.clientAvatarOne,
          schedule: ClientSchedule.future,
        ),
        ClientModel(
          id: 'client-vartika-future',
          name: 'Vartika Kaur',
          phoneNumber: '+91 9876543210',
          sessionLabel: 'Last session: Monday, 10:30 AM',
          avatarAsset: AppAssets.clientAvatarThree,
          schedule: ClientSchedule.future,
        ),
        ClientModel(
          id: 'client-meera',
          name: 'Meera Shah',
          phoneNumber: '+91 9876543210',
          sessionLabel: 'Upcoming session: Tuesday, 11:00 AM',
          avatarAsset: AppAssets.clientAvatarOne,
          schedule: ClientSchedule.future,
        ),
        ClientModel(
          id: 'client-isha',
          name: 'Isha Verma',
          phoneNumber: '+91 9876543210',
          sessionLabel: 'Upcoming session: Wednesday, 2:30 PM',
          avatarAsset: AppAssets.clientAvatarThree,
          schedule: ClientSchedule.future,
        ),
      ],
    );
  }

  @override
  Future<ClientHistoryModel> fetchClientHistory(String clientId) async {
    await simulateNetworkLatency(duration: const Duration(milliseconds: 650));

    final bool isVartika = clientId.contains('vartika');
    final ClientModel client = ClientModel(
      id: clientId,
      name: isVartika ? 'Vartika Kaur' : 'Riya Sharma',
      phoneNumber: '+91 9876543210',
      sessionLabel: 'Last session: 24 Jan 2026',
      avatarAsset:
          isVartika ? AppAssets.clientAvatarThree : AppAssets.clientAvatarOne,
      schedule: ClientSchedule.previous,
    );

    return ClientHistoryModel(
      client: client,
      age: isVartika ? 28 : 31,
      gender: 'Female',
      location: 'Delhi, India',
      isRisky: isVartika,
      totalDurationLabel: '08h 45m',
      totalEarned: 1290,
      firstSessionDate: DateTime(2026, 1, 12),
      pastSessions: <ClientSessionModel>[
        ClientSessionModel(
          id: '$clientId-past-1',
          type: ClientSessionType.voice,
          durationMinutes: 45,
          scheduledAt: DateTime(2026, 1, 24, 11, 30),
          earnings: 345,
          isUpcoming: false,
        ),
        ClientSessionModel(
          id: '$clientId-past-2',
          type: ClientSessionType.chat,
          durationMinutes: 15,
          scheduledAt: DateTime(2026, 1, 24, 10, 30),
          earnings: 115,
          isUpcoming: false,
        ),
        ClientSessionModel(
          id: '$clientId-past-3',
          type: ClientSessionType.video,
          durationMinutes: 30,
          scheduledAt: DateTime(2026, 1, 21, 17, 45),
          earnings: 225,
          isUpcoming: false,
        ),
        ClientSessionModel(
          id: '$clientId-past-4',
          type: ClientSessionType.voice,
          durationMinutes: 45,
          scheduledAt: DateTime(2026, 1, 18, 15, 30),
          earnings: 345,
          isUpcoming: false,
        ),
        ClientSessionModel(
          id: '$clientId-past-5',
          type: ClientSessionType.chat,
          durationMinutes: 20,
          scheduledAt: DateTime(2026, 1, 16, 12),
          earnings: 150,
          isUpcoming: false,
        ),
        ClientSessionModel(
          id: '$clientId-past-6',
          type: ClientSessionType.video,
          durationMinutes: 30,
          scheduledAt: DateTime(2026, 1, 14, 18),
          earnings: 225,
          isUpcoming: false,
        ),
      ],
      upcomingSessions: <ClientSessionModel>[
        ClientSessionModel(
          id: '$clientId-upcoming-1',
          type: ClientSessionType.video,
          durationMinutes: 30,
          scheduledAt: DateTime(2026, 1, 28, 16),
          earnings: 225,
          isUpcoming: true,
        ),
        ClientSessionModel(
          id: '$clientId-upcoming-2',
          type: ClientSessionType.voice,
          durationMinutes: 45,
          scheduledAt: DateTime(2026, 2, 2, 11, 30),
          earnings: 345,
          isUpcoming: true,
        ),
        ClientSessionModel(
          id: '$clientId-upcoming-3',
          type: ClientSessionType.chat,
          durationMinutes: 20,
          scheduledAt: DateTime(2026, 2, 5, 14),
          earnings: 150,
          isUpcoming: true,
        ),
        ClientSessionModel(
          id: '$clientId-upcoming-4',
          type: ClientSessionType.voice,
          durationMinutes: 30,
          scheduledAt: DateTime(2026, 2, 10, 16, 30),
          earnings: 230,
          isUpcoming: true,
        ),
      ],
    );
  }

  @override
  Future<void> saveClientNote(String clientId, String note) async {
    await simulateNetworkLatency(duration: const Duration(milliseconds: 200));
    _notes[clientId] = note;
  }

  @override
  Future<void> cancelFutureSession(String sessionId) {
    return simulateNetworkLatency(duration: const Duration(milliseconds: 250));
  }
}
