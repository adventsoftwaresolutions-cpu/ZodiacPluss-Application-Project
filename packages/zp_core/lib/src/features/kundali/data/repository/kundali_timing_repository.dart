import '../../../../shared/constants/kundali_assets.dart';
import '../models/kundali_timing_model.dart';

abstract interface class KundaliTimingRepository {
  Future<KundaliTimingData> getTiming({DateTime? asOf});
}

class StubKundaliTimingRepository implements KundaliTimingRepository {
  const StubKundaliTimingRepository();

  @override
  Future<KundaliTimingData> getTiming({DateTime? asOf}) async {
    final referenceDate = asOf ?? DateTime.now();
    final currentMahadasha = _timeline.firstWhere(
      (period) => period.contains(referenceDate),
      orElse: () => _timeline[2],
    );
    final currentAntardasha = currentMahadasha.subPeriods.isEmpty
        ? currentMahadasha
        : currentMahadasha.subPeriods.firstWhere(
            (period) => period.contains(referenceDate),
            orElse: () => currentMahadasha.subPeriods.first,
          );
    final currentIndex = currentMahadasha.subPeriods.indexOf(currentAntardasha);
    final nextIndex = currentIndex + 1;

    return KundaliTimingData(
      referenceDate: referenceDate,
      currentMahadasha: currentMahadasha,
      currentAntardasha: currentAntardasha,
      nextAntardasha:
          currentIndex >= 0 && nextIndex < currentMahadasha.subPeriods.length
              ? currentMahadasha.subPeriods[nextIndex]
              : null,
      timeline: _timeline,
      sadeSati: const KundaliSadeSatiStatus(
        isActive: true,
        phase: 'Rising phase',
        description:
            'Saturn is moving through the sign before the natal Moon sign. '
            'This is the opening phase of the current Sade Sati cycle.',
      ),
      ayanamsa: 'Lahiri',
      yearLength: 365.25,
    );
  }

  static final _venusAntardashas = [
    KundaliDashaPeriod(
      id: 3,
      name: 'Venus',
      asset: KundaliAssets.venus,
      start: DateTime(2014, 5),
      end: DateTime(2017, 9),
    ),
    KundaliDashaPeriod(
      id: 0,
      name: 'Sun',
      asset: KundaliAssets.sun,
      start: DateTime(2017, 9),
      end: DateTime(2018, 9),
    ),
    KundaliDashaPeriod(
      id: 1,
      name: 'Moon',
      asset: KundaliAssets.moon,
      start: DateTime(2018, 9),
      end: DateTime(2020, 5),
    ),
    KundaliDashaPeriod(
      id: 4,
      name: 'Mars',
      asset: KundaliAssets.mars,
      start: DateTime(2020, 5),
      end: DateTime(2021, 7),
    ),
    KundaliDashaPeriod(
      id: 101,
      name: 'Rahu',
      asset: KundaliAssets.rahu,
      start: DateTime(2021, 7),
      end: DateTime(2024, 7),
    ),
    KundaliDashaPeriod(
      id: 5,
      name: 'Jupiter',
      asset: KundaliAssets.jupiter,
      start: DateTime(2024, 7),
      end: DateTime(2027, 3),
    ),
    KundaliDashaPeriod(
      id: 6,
      name: 'Saturn',
      asset: KundaliAssets.saturn,
      start: DateTime(2027, 3),
      end: DateTime(2030, 5),
    ),
    KundaliDashaPeriod(
      id: 2,
      name: 'Mercury',
      asset: KundaliAssets.mercury,
      start: DateTime(2030, 5),
      end: DateTime(2033, 3),
    ),
    KundaliDashaPeriod(
      id: 102,
      name: 'Ketu',
      asset: KundaliAssets.ketu,
      start: DateTime(2033, 3),
      end: DateTime(2034, 5),
    ),
  ];

  static final _timeline = [
    KundaliDashaPeriod(
      id: 2,
      name: 'Mercury',
      asset: KundaliAssets.mercury,
      start: DateTime(1990, 5),
      end: DateTime(2007, 5),
    ),
    KundaliDashaPeriod(
      id: 102,
      name: 'Ketu',
      asset: KundaliAssets.ketu,
      start: DateTime(2007, 5),
      end: DateTime(2014, 5),
    ),
    KundaliDashaPeriod(
      id: 3,
      name: 'Venus',
      asset: KundaliAssets.venus,
      start: DateTime(2014, 5),
      end: DateTime(2034, 5),
      subPeriods: _venusAntardashas,
    ),
    KundaliDashaPeriod(
      id: 0,
      name: 'Sun',
      asset: KundaliAssets.sun,
      start: DateTime(2034, 5),
      end: DateTime(2040, 5),
    ),
    KundaliDashaPeriod(
      id: 1,
      name: 'Moon',
      asset: KundaliAssets.moon,
      start: DateTime(2040, 5),
      end: DateTime(2050, 5),
    ),
  ];
}
