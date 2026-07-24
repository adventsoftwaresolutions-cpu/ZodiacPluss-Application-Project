import 'package:flutter_test/flutter_test.dart';
import 'package:zp_core/zp_core.dart';

void main() {
  const calculator = KundaliPlanetStrengthCalculator();

  test('degree state reverses between odd and even signs', () {
    expect(
      calculator.degreeStateFor(1, 2),
      KundaliDegreeState.bala,
    );
    expect(
      calculator.degreeStateFor(2, 2),
      KundaliDegreeState.mrita,
    );
    expect(
      calculator.degreeStateFor(1, 14),
      KundaliDegreeState.yuva,
    );
    expect(
      calculator.degreeStateFor(2, 14),
      KundaliDegreeState.yuva,
    );
  });

  test('repository returns sorted classical placement strengths', () async {
    const repository = StubKundaliPlanetsRepository();

    final data = await repository.getPlanets();

    expect(data.positions, hasLength(13));
    expect(data.strongestPlanets, hasLength(3));
    expect(
      data.strongestPlanets.every(
        (strength) => strength.planet.supportsPlacementStrength,
      ),
      isTrue,
    );
    expect(
      data.strongestPlanets[0].score,
      greaterThanOrEqualTo(data.strongestPlanets[1].score),
    );
    expect(
      data.strongestPlanets[1].score,
      greaterThanOrEqualTo(data.strongestPlanets[2].score),
    );
  });
}
