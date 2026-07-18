import 'kundali_planet_model.dart';

enum KundaliDoshaId { mangal, kaalSarp }

class KundaliDoshaResult {
  const KundaliDoshaResult({
    required this.id,
    required this.name,
    required this.hasDosha,
    required this.description,
    this.type,
    this.hasException = false,
    this.exceptions = const [],
    this.remedies = const [],
  });

  factory KundaliDoshaResult.fromJson(Map<String, dynamic> json) {
    return KundaliDoshaResult(
      id: KundaliDoshaId.values.byName(json['id'] as String),
      name: json['name'] as String,
      hasDosha: json['has_dosha'] as bool,
      description: json['description'] as String,
      type: json['type'] as String?,
      hasException: json['has_exception'] as bool? ?? false,
      exceptions: (json['exceptions'] as List<dynamic>? ?? const [])
          .map((exception) => exception as String)
          .toList(growable: false),
      remedies: (json['remedies'] as List<dynamic>? ?? const [])
          .map((remedy) => remedy as String)
          .toList(growable: false),
    );
  }

  final KundaliDoshaId id;
  final String name;
  final bool hasDosha;
  final String description;
  final String? type;
  final bool hasException;
  final List<String> exceptions;
  final List<String> remedies;

  Map<String, dynamic> toJson() => {
        'id': id.name,
        'name': name,
        'has_dosha': hasDosha,
        'description': description,
        'type': type,
        'has_exception': hasException,
        'exceptions': exceptions,
        'remedies': remedies,
      };
}

class KundaliPapaPlanetResult {
  const KundaliPapaPlanetResult({
    required this.planet,
    required this.position,
    required this.hasDosha,
  });

  factory KundaliPapaPlanetResult.fromJson(Map<String, dynamic> json) {
    return KundaliPapaPlanetResult(
      planet: KundaliPlanetId.values.byName(json['planet'] as String),
      position: json['position'] as int,
      hasDosha: json['has_dosha'] as bool,
    );
  }

  final KundaliPlanetId planet;
  final int position;
  final bool hasDosha;

  Map<String, dynamic> toJson() => {
        'planet': planet.name,
        'position': position,
        'has_dosha': hasDosha,
      };
}

class KundaliPapaReference {
  const KundaliPapaReference({
    required this.name,
    required this.planets,
  });

  factory KundaliPapaReference.fromJson(Map<String, dynamic> json) {
    return KundaliPapaReference(
      name: json['name'] as String,
      planets: (json['planets'] as List<dynamic>)
          .map(
            (item) => KundaliPapaPlanetResult.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
    );
  }

  final String name;
  final List<KundaliPapaPlanetResult> planets;

  List<KundaliPapaPlanetResult> get detectedPlanets =>
      planets.where((planet) => planet.hasDosha).toList(growable: false);

  Map<String, dynamic> toJson() => {
        'name': name,
        'planets': planets.map((planet) => planet.toJson()).toList(),
      };
}

class KundaliPapaSamyamResult {
  const KundaliPapaSamyamResult({
    required this.totalPoints,
    required this.references,
  });

  factory KundaliPapaSamyamResult.fromJson(Map<String, dynamic> json) {
    return KundaliPapaSamyamResult(
      totalPoints: (json['total_points'] as num).toDouble(),
      references: (json['references'] as List<dynamic>)
          .map(
            (item) => KundaliPapaReference.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
    );
  }

  final double totalPoints;
  final List<KundaliPapaReference> references;

  int get detectedPlacementCount => references.fold(
        0,
        (total, reference) => total + reference.detectedPlanets.length,
      );

  Map<String, dynamic> toJson() => {
        'total_points': totalPoints,
        'references':
            references.map((reference) => reference.toJson()).toList(),
      };
}

class KundaliDoshasData {
  const KundaliDoshasData({
    required this.mangal,
    required this.kaalSarp,
    required this.papaSamyam,
    required this.ayanamsa,
  });

  factory KundaliDoshasData.fromJson(Map<String, dynamic> json) {
    return KundaliDoshasData(
      mangal: KundaliDoshaResult.fromJson(
        json['mangal_dosha'] as Map<String, dynamic>,
      ),
      kaalSarp: KundaliDoshaResult.fromJson(
        json['kaal_sarp_dosha'] as Map<String, dynamic>,
      ),
      papaSamyam: KundaliPapaSamyamResult.fromJson(
        json['papa_samyam'] as Map<String, dynamic>,
      ),
      ayanamsa: json['ayanamsa'] as String,
    );
  }

  final KundaliDoshaResult mangal;
  final KundaliDoshaResult kaalSarp;
  final KundaliPapaSamyamResult papaSamyam;
  final String ayanamsa;

  int get detectedDoshaCount =>
      [mangal, kaalSarp].where((result) => result.hasDosha).length;

  Map<String, dynamic> toJson() => {
        'mangal_dosha': mangal.toJson(),
        'kaal_sarp_dosha': kaalSarp.toJson(),
        'papa_samyam': papaSamyam.toJson(),
        'ayanamsa': ayanamsa,
      };
}
