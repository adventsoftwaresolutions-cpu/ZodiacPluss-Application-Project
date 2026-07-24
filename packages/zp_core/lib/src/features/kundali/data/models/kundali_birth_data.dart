import 'kundali_chart_model.dart';

/// Engine-neutral birth inputs required for astronomical Kundali calculation.
///
/// [birthDateTimeUtc] avoids ambiguous local times and daylight-saving rules.
/// [timeZoneId] is retained for display and audit purposes. Coordinates use
/// signed decimal degrees (north/east positive).
class KundaliBirthData {
  const KundaliBirthData({
    required this.birthDateTimeUtc,
    required this.latitude,
    required this.longitude,
    required this.timeZoneId,
    this.placeName,
    this.subjectId,
  })  : assert(latitude >= -90 && latitude <= 90),
        assert(longitude >= -180 && longitude <= 180);

  factory KundaliBirthData.fromJson(Map<String, dynamic> json) {
    return KundaliBirthData(
      birthDateTimeUtc:
          DateTime.parse(json['birth_date_time_utc'] as String).toUtc(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timeZoneId: json['time_zone_id'] as String,
      placeName: json['place_name'] as String?,
      subjectId: json['subject_id'] as String?,
    );
  }

  final DateTime birthDateTimeUtc;
  final double latitude;
  final double longitude;
  final String timeZoneId;
  final String? placeName;
  final String? subjectId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'birth_date_time_utc': birthDateTimeUtc.toUtc().toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
        'time_zone_id': timeZoneId,
        'place_name': placeName,
        'subject_id': subjectId,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is KundaliBirthData &&
            birthDateTimeUtc == other.birthDateTimeUtc &&
            latitude == other.latitude &&
            longitude == other.longitude &&
            timeZoneId == other.timeZoneId &&
            placeName == other.placeName &&
            subjectId == other.subjectId;
  }

  @override
  int get hashCode => Object.hash(
        birthDateTimeUtc,
        latitude,
        longitude,
        timeZoneId,
        placeName,
        subjectId,
      );
}

class KundaliChartQuery {
  const KundaliChartQuery({
    required this.birthData,
    required this.chart,
  });

  final KundaliBirthData birthData;
  final KundaliChartRequest chart;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is KundaliChartQuery &&
            birthData == other.birthData &&
            chart == other.chart;
  }

  @override
  int get hashCode => Object.hash(birthData, chart);
}

class KundaliTimingQuery {
  const KundaliTimingQuery({
    required this.birthData,
    this.asOf,
  });

  final KundaliBirthData birthData;
  final DateTime? asOf;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is KundaliTimingQuery &&
            birthData == other.birthData &&
            asOf == other.asOf;
  }

  @override
  int get hashCode => Object.hash(birthData, asOf);
}
