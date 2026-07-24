class KundaliDashaPeriod {
  const KundaliDashaPeriod({
    required this.id,
    required this.name,
    required this.asset,
    required this.start,
    required this.end,
    this.subPeriods = const [],
  });

  factory KundaliDashaPeriod.fromJson(Map<String, dynamic> json) {
    return KundaliDashaPeriod(
      id: json['id'] as int,
      name: json['name'] as String,
      asset: json['asset'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      subPeriods: (json['sub_periods'] as List<dynamic>? ?? const [])
          .map(
            (item) => KundaliDashaPeriod.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
    );
  }

  final int id;
  final String name;
  final String asset;
  final DateTime start;
  final DateTime end;
  final List<KundaliDashaPeriod> subPeriods;

  bool contains(DateTime date) => !date.isBefore(start) && date.isBefore(end);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'asset': asset,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'sub_periods': subPeriods.map((period) => period.toJson()).toList(),
      };
}

class KundaliSadeSatiStatus {
  const KundaliSadeSatiStatus({
    required this.isActive,
    required this.phase,
    required this.description,
  });

  factory KundaliSadeSatiStatus.fromJson(Map<String, dynamic> json) {
    return KundaliSadeSatiStatus(
      isActive: (json['is_in_sade_sati'] ?? json['is_active']) as bool,
      phase: (json['transit_phase'] ?? json['phase']) as String,
      description: json['description'] as String,
    );
  }

  final bool isActive;
  final String phase;
  final String description;

  Map<String, dynamic> toJson() => {
        'is_in_sade_sati': isActive,
        'transit_phase': phase,
        'description': description,
      };
}

class KundaliTimingData {
  const KundaliTimingData({
    required this.referenceDate,
    required this.currentMahadasha,
    required this.currentAntardasha,
    required this.nextAntardasha,
    required this.timeline,
    required this.sadeSati,
    required this.ayanamsa,
    required this.yearLength,
  });

  factory KundaliTimingData.fromJson(Map<String, dynamic> json) {
    return KundaliTimingData(
      referenceDate: DateTime.parse(json['reference_date'] as String),
      currentMahadasha: KundaliDashaPeriod.fromJson(
        json['current_mahadasha'] as Map<String, dynamic>,
      ),
      currentAntardasha: KundaliDashaPeriod.fromJson(
        json['current_antardasha'] as Map<String, dynamic>,
      ),
      nextAntardasha: json['next_antardasha'] == null
          ? null
          : KundaliDashaPeriod.fromJson(
              json['next_antardasha'] as Map<String, dynamic>,
            ),
      timeline: (json['timeline'] as List<dynamic>)
          .map(
            (item) => KundaliDashaPeriod.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
      sadeSati: KundaliSadeSatiStatus.fromJson(
        json['sade_sati'] as Map<String, dynamic>,
      ),
      ayanamsa: json['ayanamsa'] as String,
      yearLength: (json['year_length'] as num).toDouble(),
    );
  }

  final DateTime referenceDate;
  final KundaliDashaPeriod currentMahadasha;
  final KundaliDashaPeriod currentAntardasha;
  final KundaliDashaPeriod? nextAntardasha;
  final List<KundaliDashaPeriod> timeline;
  final KundaliSadeSatiStatus sadeSati;
  final String ayanamsa;
  final double yearLength;

  double get antardashaProgress {
    final total = currentAntardasha.end.difference(currentAntardasha.start);
    final elapsed = referenceDate.difference(currentAntardasha.start);
    if (total.inSeconds <= 0) return 0;
    return (elapsed.inSeconds / total.inSeconds).clamp(0.0, 1.0);
  }

  String get remainingLabel {
    final days = currentAntardasha.end.difference(referenceDate).inDays;
    if (days <= 0) return 'Ending now';
    if (days >= 365) {
      final years = days ~/ 365;
      final months = (days % 365) ~/ 30;
      return months == 0
          ? '$years year${years == 1 ? '' : 's'} remaining'
          : '${years}y ${months}m remaining';
    }
    if (days >= 30) {
      final months = days ~/ 30;
      final remainingDays = days % 30;
      return remainingDays == 0
          ? '$months month${months == 1 ? '' : 's'} remaining'
          : '${months}m ${remainingDays}d remaining';
    }
    return '$days day${days == 1 ? '' : 's'} remaining';
  }

  Map<String, dynamic> toJson() => {
        'reference_date': referenceDate.toIso8601String(),
        'current_mahadasha': currentMahadasha.toJson(),
        'current_antardasha': currentAntardasha.toJson(),
        'next_antardasha': nextAntardasha?.toJson(),
        'timeline': timeline.map((period) => period.toJson()).toList(),
        'sade_sati': sadeSati.toJson(),
        'ayanamsa': ayanamsa,
        'year_length': yearLength,
      };
}
