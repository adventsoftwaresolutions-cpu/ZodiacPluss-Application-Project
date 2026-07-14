enum ClientSchedule { previous, future }

class ClientModel {
  const ClientModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.sessionLabel,
    required this.avatarAsset,
    required this.schedule,
  });

  final String id;
  final String name;
  final String phoneNumber;
  final String sessionLabel;
  final String avatarAsset;
  final ClientSchedule schedule;
}
