import '../../../../shared/constants/app_assets.dart';
import '../models/kundali_planet_model.dart';
import 'kundali_planet_strength_calculator.dart';

abstract interface class KundaliPlanetsRepository {
  Future<KundaliPlanetsData> getPlanets();
}

class StubKundaliPlanetsRepository implements KundaliPlanetsRepository {
  const StubKundaliPlanetsRepository({
    this.calculator = const KundaliPlanetStrengthCalculator(),
  });

  final KundaliPlanetStrengthCalculator calculator;

  @override
  Future<KundaliPlanetsData> getPlanets() async {
    const positions = _positions;
    return KundaliPlanetsData(
      positions: positions,
      strongestPlanets: calculator.calculate(positions).take(3).toList(),
    );
  }

  static const _positions = [
    KundaliPlanetPosition(
      planet: KundaliPlanetId.ascendant,
      signId: 9,
      sign: 'Sagittarius',
      signLord: KundaliPlanetId.jupiter,
      degree: 28.4394,
      nakshatra: 'Uttara Ashadha',
      nakshatraLord: 'Sun',
      house: 1,
    ),
    KundaliPlanetPosition(
      planet: KundaliPlanetId.sun,
      signId: 7,
      sign: 'Libra',
      signLord: KundaliPlanetId.venus,
      degree: 5.92,
      nakshatra: 'Chitra',
      nakshatraLord: 'Mars',
      house: 11,
      asset: AppAssets.kundaliSun,
    ),
    KundaliPlanetPosition(
      planet: KundaliPlanetId.moon,
      signId: 11,
      sign: 'Aquarius',
      signLord: KundaliPlanetId.saturn,
      degree: 28.3544,
      nakshatra: 'Purva Bhadrapada',
      nakshatraLord: 'Jupiter',
      house: 9,
      asset: AppAssets.kundaliMoon,
    ),
    KundaliPlanetPosition(
      planet: KundaliPlanetId.mercury,
      signId: 6,
      sign: 'Virgo',
      signLord: KundaliPlanetId.mercury,
      degree: 15.34,
      nakshatra: 'Hasta',
      nakshatraLord: 'Moon',
      house: 10,
      asset: AppAssets.kundaliMercury,
    ),
    KundaliPlanetPosition(
      planet: KundaliPlanetId.venus,
      signId: 12,
      sign: 'Pisces',
      signLord: KundaliPlanetId.jupiter,
      degree: 14.22,
      nakshatra: 'Uttara Bhadrapada',
      nakshatraLord: 'Saturn',
      house: 4,
      asset: AppAssets.kundaliVenus,
    ),
    KundaliPlanetPosition(
      planet: KundaliPlanetId.mars,
      signId: 6,
      sign: 'Virgo',
      signLord: KundaliPlanetId.mercury,
      degree: 28.3544,
      nakshatra: 'Chitra',
      nakshatraLord: 'Mars',
      house: 10,
      asset: AppAssets.kundaliMars,
    ),
    KundaliPlanetPosition(
      planet: KundaliPlanetId.jupiter,
      signId: 9,
      sign: 'Sagittarius',
      signLord: KundaliPlanetId.jupiter,
      degree: 14.46,
      nakshatra: 'Purva Ashadha',
      nakshatraLord: 'Venus',
      house: 1,
      asset: AppAssets.kundaliJupiter,
    ),
    KundaliPlanetPosition(
      planet: KundaliPlanetId.saturn,
      signId: 4,
      sign: 'Cancer',
      signLord: KundaliPlanetId.moon,
      degree: 5.92,
      nakshatra: 'Pushya',
      nakshatraLord: 'Saturn',
      house: 8,
      asset: AppAssets.kundaliSaturn,
      isRetrograde: true,
    ),
    KundaliPlanetPosition(
      planet: KundaliPlanetId.rahu,
      signId: 1,
      sign: 'Aries',
      signLord: KundaliPlanetId.mars,
      degree: 28.3544,
      nakshatra: 'Krittika',
      nakshatraLord: 'Sun',
      house: 6,
      asset: AppAssets.kundaliRahu,
      isRetrograde: true,
    ),
    KundaliPlanetPosition(
      planet: KundaliPlanetId.ketu,
      signId: 7,
      sign: 'Libra',
      signLord: KundaliPlanetId.venus,
      degree: 28.4394,
      nakshatra: 'Vishakha',
      nakshatraLord: 'Jupiter',
      house: 12,
      asset: AppAssets.kundaliKetu,
      isRetrograde: true,
    ),
    KundaliPlanetPosition(
      planet: KundaliPlanetId.neptune,
      signId: 10,
      sign: 'Capricorn',
      signLord: KundaliPlanetId.saturn,
      degree: 5.92,
      nakshatra: 'Uttara Ashadha',
      nakshatraLord: 'Sun',
      house: 3,
      asset: AppAssets.kundaliNeptune,
    ),
    KundaliPlanetPosition(
      planet: KundaliPlanetId.uranus,
      signId: 11,
      sign: 'Aquarius',
      signLord: KundaliPlanetId.saturn,
      degree: 28.3544,
      nakshatra: 'Purva Bhadrapada',
      nakshatraLord: 'Jupiter',
      house: 4,
      asset: AppAssets.kundaliUranus,
    ),
    KundaliPlanetPosition(
      planet: KundaliPlanetId.pluto,
      signId: 8,
      sign: 'Scorpio',
      signLord: KundaliPlanetId.mars,
      degree: 5.92,
      nakshatra: 'Anuradha',
      nakshatraLord: 'Saturn',
      house: 1,
      asset: AppAssets.kundaliPluto,
    ),
  ];
}
