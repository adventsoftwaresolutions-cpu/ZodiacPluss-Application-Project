enum KundaliPlanetId {
  ascendant('Ascendant'),
  sun('Sun'),
  moon('Moon'),
  mercury('Mercury'),
  venus('Venus'),
  mars('Mars'),
  jupiter('Jupiter'),
  saturn('Saturn'),
  rahu('Rahu'),
  ketu('Ketu'),
  uranus('Uranus'),
  neptune('Neptune'),
  pluto('Pluto');

  const KundaliPlanetId(this.label);

  final String label;

  bool get supportsPlacementStrength => switch (this) {
        sun || moon || mercury || venus || mars || jupiter || saturn => true,
        _ => false,
      };
}

enum KundaliDegreeState {
  bala('Bala', 'Developing degree phase', 8),
  kumara('Kumara', 'Growing degree phase', 16),
  yuva('Yuva', 'Peak degree phase', 30),
  vriddha('Vriddha', 'Declining degree phase', 16),
  mrita('Mrita', 'Low degree expression', 4);

  const KundaliDegreeState(this.label, this.description, this.score);

  final String label;
  final String description;
  final double score;
}

class KundaliPlanetPosition {
  const KundaliPlanetPosition({
    required this.planet,
    required this.signId,
    required this.sign,
    required this.signLord,
    required this.degree,
    required this.nakshatra,
    required this.nakshatraLord,
    required this.house,
    this.asset,
    this.isRetrograde = false,
  });

  factory KundaliPlanetPosition.fromJson(Map<String, dynamic> json) {
    return KundaliPlanetPosition(
      planet: KundaliPlanetId.values.byName(json['planet'] as String),
      signId: json['sign_id'] as int,
      sign: json['sign'] as String,
      signLord: KundaliPlanetId.values.byName(json['sign_lord'] as String),
      degree: (json['degree'] as num).toDouble(),
      nakshatra: json['nakshatra'] as String,
      nakshatraLord: json['nakshatra_lord'] as String,
      house: json['house'] as int,
      asset: json['asset'] as String?,
      isRetrograde: json['is_retrograde'] as bool? ?? false,
    );
  }

  final KundaliPlanetId planet;
  final int signId;
  final String sign;
  final KundaliPlanetId signLord;
  final double degree;
  final String nakshatra;
  final String nakshatraLord;
  final int house;
  final String? asset;
  final bool isRetrograde;

  String get degreeLabel {
    final totalSeconds = (degree * 3600).round();
    final degrees = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '$degrees°${minutes.toString().padLeft(2, '0')}′'
        '${seconds.toString().padLeft(2, '0')}″';
  }

  Map<String, dynamic> toJson() => {
        'planet': planet.name,
        'sign_id': signId,
        'sign': sign,
        'sign_lord': signLord.name,
        'degree': degree,
        'nakshatra': nakshatra,
        'nakshatra_lord': nakshatraLord,
        'house': house,
        'asset': asset,
        'is_retrograde': isRetrograde,
      };
}

class KundaliPlanetStrength {
  const KundaliPlanetStrength({
    required this.planet,
    required this.asset,
    required this.score,
    required this.label,
    required this.degreeState,
    required this.reasons,
  });

  factory KundaliPlanetStrength.fromJson(Map<String, dynamic> json) {
    return KundaliPlanetStrength(
      planet: KundaliPlanetId.values.byName(json['planet'] as String),
      asset: json['asset'] as String,
      score: json['score'] as int,
      label: json['label'] as String,
      degreeState:
          KundaliDegreeState.values.byName(json['degree_state'] as String),
      reasons: (json['reasons'] as List<dynamic>)
          .map((reason) => reason as String)
          .toList(growable: false),
    );
  }

  final KundaliPlanetId planet;
  final String asset;
  final int score;
  final String label;
  final KundaliDegreeState degreeState;
  final List<String> reasons;

  Map<String, dynamic> toJson() => {
        'planet': planet.name,
        'asset': asset,
        'score': score,
        'label': label,
        'degree_state': degreeState.name,
        'reasons': reasons,
      };
}

class KundaliPlanetsData {
  const KundaliPlanetsData({
    required this.positions,
    required this.strongestPlanets,
  });

  factory KundaliPlanetsData.fromJson(Map<String, dynamic> json) {
    return KundaliPlanetsData(
      positions: (json['positions'] as List<dynamic>)
          .map(
            (item) => KundaliPlanetPosition.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
      strongestPlanets: (json['strongest_planets'] as List<dynamic>)
          .map(
            (item) => KundaliPlanetStrength.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
    );
  }

  final List<KundaliPlanetPosition> positions;
  final List<KundaliPlanetStrength> strongestPlanets;

  Map<String, dynamic> toJson() => {
        'positions': positions.map((position) => position.toJson()).toList(),
        'strongest_planets':
            strongestPlanets.map((strength) => strength.toJson()).toList(),
      };
}
