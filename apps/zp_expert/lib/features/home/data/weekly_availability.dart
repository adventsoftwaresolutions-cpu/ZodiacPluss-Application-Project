import 'package:flutter/foundation.dart';

enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension WeekdayLabel on Weekday {
  String get label {
    switch (this) {
      case Weekday.monday:
        return 'Monday';
      case Weekday.tuesday:
        return 'Tuesday';
      case Weekday.wednesday:
        return 'Wednesday';
      case Weekday.thursday:
        return 'Thursday';
      case Weekday.friday:
        return 'Friday';
      case Weekday.saturday:
        return 'Saturday';
      case Weekday.sunday:
        return 'Sunday';
    }
  }
}

@immutable
class AvailabilityTime {
  const AvailabilityTime({required this.hour, required this.minute});

  factory AvailabilityTime.fromJson(Map<String, dynamic> json) {
    return AvailabilityTime(
      hour: json['hour'] as int,
      minute: json['minute'] as int,
    );
  }

  final int hour; // 0-23
  final int minute; // 0-59

  Map<String, dynamic> toJson() => <String, dynamic>{
        'hour': hour,
        'minute': minute,
      };

  String get formatted {
    final int displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final String period = hour >= 12 ? 'PM' : 'AM';
    final String minuteStr = minute.toString().padLeft(2, '0');
    return '$displayHour:$minuteStr $period';
  }

  /// Total minutes since midnight — useful for sorting/validation
  /// (e.g. ensuring `to` is after `from`) without comparing two fields.
  int get minutesSinceMidnight => hour * 60 + minute;
}

@immutable
class DaySchedule {
  const DaySchedule({
    required this.weekday,
    required this.from,
    required this.to,
    required this.isEnabled,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      weekday: Weekday.values.byName(json['weekday'] as String),
      from: AvailabilityTime.fromJson(
        json['from'] as Map<String, dynamic>,
      ),
      to: AvailabilityTime.fromJson(json['to'] as Map<String, dynamic>),
      isEnabled: json['isEnabled'] as bool,
    );
  }

  final Weekday weekday;
  final AvailabilityTime from;
  final AvailabilityTime to;
  final bool isEnabled;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'weekday': weekday.name,
        'from': from.toJson(),
        'to': to.toJson(),
        'isEnabled': isEnabled,
      };

  DaySchedule copyWith({
    AvailabilityTime? from,
    AvailabilityTime? to,
    bool? isEnabled,
  }) {
    return DaySchedule(
      weekday: weekday,
      from: from ?? this.from,
      to: to ?? this.to,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

@immutable
class WeeklyAvailability {
  const WeeklyAvailability({required this.days});

  factory WeeklyAvailability.defaultSchedule() {
    const AvailabilityTime defaultFrom = AvailabilityTime(hour: 9, minute: 30);
    const AvailabilityTime defaultTo = AvailabilityTime(hour: 9, minute: 30);

    return WeeklyAvailability(
      days: Weekday.values
          .map(
            (Weekday day) => DaySchedule(
              weekday: day,
              from: defaultFrom,
              to: defaultTo,
              isEnabled: day != Weekday.saturday && day != Weekday.sunday,
            ),
          )
          .toList(),
    );
  }

  factory WeeklyAvailability.fromJson(Map<String, dynamic> json) {
    return WeeklyAvailability(
      days: (json['days'] as List<dynamic>)
          .map((dynamic d) => DaySchedule.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<DaySchedule> days;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'days': days.map((DaySchedule d) => d.toJson()).toList(),
      };

  WeeklyAvailability updateDay(
    Weekday weekday,
    DaySchedule Function(DaySchedule current) update,
  ) {
    return WeeklyAvailability(
      days: days.map((DaySchedule d) {
        return d.weekday == weekday ? update(d) : d;
      }).toList(),
    );
  }
}