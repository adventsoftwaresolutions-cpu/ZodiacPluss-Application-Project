import '../../../../shared/constants/app_assets.dart';
import '../models/client_lists.dart';
import '../models/client_model.dart';

abstract class ClientRepository {
  Future<ClientLists> fetchClients();
}

/// Temporary local source. A Supabase or Express API implementation can
/// replace this class without changing the provider or presentation layer.
class LocalClientRepository implements ClientRepository {
  @override
  Future<ClientLists> fetchClients() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

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
}
