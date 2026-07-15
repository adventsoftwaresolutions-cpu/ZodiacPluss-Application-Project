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

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      sessionLabel: json['sessionLabel'] as String,
      avatarAsset: json['avatarAsset'] as String,
      schedule: ClientSchedule.values.byName(json['schedule'] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'sessionLabel': sessionLabel,
        'avatarAsset': avatarAsset,
        'schedule': schedule.name,
      };
}
