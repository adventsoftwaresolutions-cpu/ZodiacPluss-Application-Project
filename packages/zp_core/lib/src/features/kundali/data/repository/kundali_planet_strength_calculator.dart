import '../models/kundali_planet_model.dart';

class KundaliPlanetStrengthCalculator {
  const KundaliPlanetStrengthCalculator();

  List<KundaliPlanetStrength> calculate(
    List<KundaliPlanetPosition> positions,
  ) {
    final strengths = positions
        .where((position) => position.planet.supportsPlacementStrength)
        .map(_calculatePlanet)
        .toList(growable: false)
      ..sort((first, second) => second.score.compareTo(first.score));
    return strengths;
  }

  KundaliPlanetStrength _calculatePlanet(KundaliPlanetPosition position) {
    final degreeState = degreeStateFor(position.signId, position.degree);
    final dignity = _dignityFor(position);
    final house = _houseStrength(position.house);
    final motion = position.isRetrograde ? 8.0 : 0.0;
    final rawScore = degreeState.score + dignity.score + house.score + motion;
    final score = ((rawScore / 91) * 100).round().clamp(0, 100);
    final reasons = <String>[
      '${degreeState.label}: ${degreeState.description.toLowerCase()}',
      dignity.description,
      house.description,
      if (position.isRetrograde) 'Retrograde motion adds expression strength',
    ];

    return KundaliPlanetStrength(
      planet: position.planet,
      asset: position.asset!,
      score: score,
      label: switch (score) {
        >= 75 => 'Very strong',
        >= 60 => 'Strong',
        >= 45 => 'Balanced',
        _ => 'Developing',
      },
      degreeState: degreeState,
      reasons: reasons,
    );
  }

  KundaliDegreeState degreeStateFor(int signId, double degree) {
    final segment = (degree.clamp(0, 29.999999) ~/ 6).clamp(0, 4);
    const oddSignStates = [
      KundaliDegreeState.bala,
      KundaliDegreeState.kumara,
      KundaliDegreeState.yuva,
      KundaliDegreeState.vriddha,
      KundaliDegreeState.mrita,
    ];
    const evenSignStates = [
      KundaliDegreeState.mrita,
      KundaliDegreeState.vriddha,
      KundaliDegreeState.yuva,
      KundaliDegreeState.kumara,
      KundaliDegreeState.bala,
    ];
    return signId.isOdd ? oddSignStates[segment] : evenSignStates[segment];
  }

  _StrengthPart _dignityFor(KundaliPlanetPosition position) {
    if (_exaltationSigns[position.planet] == position.signId) {
      return _StrengthPart(35, 'Exalted in ${position.sign}');
    }
    if (_debilitationSigns[position.planet] == position.signId) {
      return _StrengthPart(0, 'Debilitated in ${position.sign}');
    }
    if (_ownSigns[position.planet]?.contains(position.signId) ?? false) {
      return _StrengthPart(30, 'Own-sign placement in ${position.sign}');
    }
    if (_naturalFriends[position.planet]?.contains(position.signLord) ??
        false) {
      return const _StrengthPart(22, 'Placed in a friendly sign');
    }
    if (_naturalEnemies[position.planet]?.contains(position.signLord) ??
        false) {
      return const _StrengthPart(7, 'Placed in an unfriendly sign');
    }
    return const _StrengthPart(15, 'Placed in a neutral sign');
  }

  _StrengthPart _houseStrength(int house) {
    return switch (house) {
      1 || 4 || 7 || 10 => _StrengthPart(18, 'Angular house $house support'),
      5 || 9 => _StrengthPart(15, 'Trinal house $house support'),
      3 || 11 => _StrengthPart(10, 'Growth-oriented house $house'),
      2 => const _StrengthPart(8, 'House 2 gives moderate support'),
      6 => const _StrengthPart(5, 'House 6 gives mixed support'),
      _ => _StrengthPart(0, 'House $house gives limited placement support'),
    };
  }

  static const _exaltationSigns = {
    KundaliPlanetId.sun: 1,
    KundaliPlanetId.moon: 2,
    KundaliPlanetId.mars: 10,
    KundaliPlanetId.mercury: 6,
    KundaliPlanetId.jupiter: 4,
    KundaliPlanetId.venus: 12,
    KundaliPlanetId.saturn: 7,
  };

  static const _debilitationSigns = {
    KundaliPlanetId.sun: 7,
    KundaliPlanetId.moon: 8,
    KundaliPlanetId.mars: 4,
    KundaliPlanetId.mercury: 12,
    KundaliPlanetId.jupiter: 10,
    KundaliPlanetId.venus: 6,
    KundaliPlanetId.saturn: 1,
  };

  static const _ownSigns = {
    KundaliPlanetId.sun: {5},
    KundaliPlanetId.moon: {4},
    KundaliPlanetId.mars: {1, 8},
    KundaliPlanetId.mercury: {3, 6},
    KundaliPlanetId.jupiter: {9, 12},
    KundaliPlanetId.venus: {2, 7},
    KundaliPlanetId.saturn: {10, 11},
  };

  static const _naturalFriends = {
    KundaliPlanetId.sun: {
      KundaliPlanetId.moon,
      KundaliPlanetId.mars,
      KundaliPlanetId.jupiter,
    },
    KundaliPlanetId.moon: {KundaliPlanetId.sun, KundaliPlanetId.mercury},
    KundaliPlanetId.mars: {
      KundaliPlanetId.sun,
      KundaliPlanetId.moon,
      KundaliPlanetId.jupiter,
    },
    KundaliPlanetId.mercury: {KundaliPlanetId.sun, KundaliPlanetId.venus},
    KundaliPlanetId.jupiter: {
      KundaliPlanetId.sun,
      KundaliPlanetId.moon,
      KundaliPlanetId.mars,
    },
    KundaliPlanetId.venus: {KundaliPlanetId.mercury, KundaliPlanetId.saturn},
    KundaliPlanetId.saturn: {KundaliPlanetId.mercury, KundaliPlanetId.venus},
  };

  static const _naturalEnemies = {
    KundaliPlanetId.sun: {KundaliPlanetId.venus, KundaliPlanetId.saturn},
    KundaliPlanetId.moon: <KundaliPlanetId>{},
    KundaliPlanetId.mars: {KundaliPlanetId.mercury},
    KundaliPlanetId.mercury: {KundaliPlanetId.moon},
    KundaliPlanetId.jupiter: {
      KundaliPlanetId.mercury,
      KundaliPlanetId.venus,
    },
    KundaliPlanetId.venus: {KundaliPlanetId.sun, KundaliPlanetId.moon},
    KundaliPlanetId.saturn: {
      KundaliPlanetId.sun,
      KundaliPlanetId.moon,
      KundaliPlanetId.mars,
    },
  };
}

class _StrengthPart {
  const _StrengthPart(this.score, this.description);

  final double score;
  final String description;
}
