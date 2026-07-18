import '../models/kundali_dosha_model.dart';
import '../models/kundali_planet_model.dart';

abstract interface class KundaliDoshasRepository {
  Future<KundaliDoshasData> getDoshas();
}

class StubKundaliDoshasRepository implements KundaliDoshasRepository {
  const StubKundaliDoshasRepository();

  @override
  Future<KundaliDoshasData> getDoshas() async {
    return const KundaliDoshasData(
      ayanamsa: 'Lahiri',
      mangal: KundaliDoshaResult(
        id: KundaliDoshaId.mangal,
        name: 'Mangal Dosha',
        hasDosha: true,
        type: 'Mild',
        hasException: true,
        description:
            'Mars is positioned in a Mangal Dosha house. The calculated '
            'result is mild and includes cancellation conditions.',
        exceptions: [
          'The effect of Mars is considered to reduce after its maturity age.',
          'A birth on Tuesday is listed as a cancellation condition.',
        ],
        remedies: [
          'API-provided remedies are retained in the data contract but are not '
              'shown automatically.',
        ],
      ),
      kaalSarp: KundaliDoshaResult(
        id: KundaliDoshaId.kaalSarp,
        name: 'Kaal Sarp Dosha',
        hasDosha: false,
        description:
            'The planets are not all positioned between Rahu and Ketu, so Kaal '
            'Sarp Dosha is not detected.',
      ),
      papaSamyam: KundaliPapaSamyamResult(
        totalPoints: 2.75,
        references: [
          KundaliPapaReference(
            name: 'Ascendant',
            planets: [
              KundaliPapaPlanetResult(
                planet: KundaliPlanetId.mars,
                position: 10,
                hasDosha: false,
              ),
              KundaliPapaPlanetResult(
                planet: KundaliPlanetId.saturn,
                position: 5,
                hasDosha: false,
              ),
            ],
          ),
          KundaliPapaReference(
            name: 'Moon',
            planets: [
              KundaliPapaPlanetResult(
                planet: KundaliPlanetId.mars,
                position: 7,
                hasDosha: true,
              ),
              KundaliPapaPlanetResult(
                planet: KundaliPlanetId.saturn,
                position: 2,
                hasDosha: true,
              ),
            ],
          ),
          KundaliPapaReference(
            name: 'Venus',
            planets: [
              KundaliPapaPlanetResult(
                planet: KundaliPlanetId.sun,
                position: 8,
                hasDosha: true,
              ),
              KundaliPapaPlanetResult(
                planet: KundaliPlanetId.rahu,
                position: 3,
                hasDosha: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
