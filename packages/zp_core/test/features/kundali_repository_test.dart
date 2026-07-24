import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_core/zp_core.dart';

void main() {
  final birthData = KundaliBirthData(
    birthDateTimeUtc: DateTime.utc(1994, 3, 18, 4, 45),
    latitude: 19.076,
    longitude: 72.8777,
    timeZoneId: 'Asia/Kolkata',
    placeName: 'Mumbai',
    subjectId: 'client-42',
  );

  test('birth inputs round-trip without losing engine data', () {
    final restored = KundaliBirthData.fromJson(birthData.toJson());

    expect(restored, birthData);
    expect(restored.birthDateTimeUtc.isUtc, isTrue);
  });

  test('repository override receives the selected birth inputs', () async {
    final repository = _RecordingKundaliRepository();
    final container = ProviderContainer(
      overrides: <Override>[
        kundaliRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final planets =
        await container.read(kundaliPlanetsProvider(birthData).future);

    expect(planets.positions, isNotEmpty);
    expect(repository.lastBirthData, birthData);
  });
}

class _RecordingKundaliRepository implements KundaliRepository {
  final StubKundaliRepository _delegate = const StubKundaliRepository();
  KundaliBirthData? lastBirthData;

  @override
  Future<KundaliChartData> getChart(
    KundaliBirthData birthData,
    KundaliChartRequest request,
  ) {
    lastBirthData = birthData;
    return _delegate.getChart(birthData, request);
  }

  @override
  Future<KundaliDoshasData> getDoshas(KundaliBirthData birthData) {
    lastBirthData = birthData;
    return _delegate.getDoshas(birthData);
  }

  @override
  Future<KundaliPlanetsData> getPlanets(KundaliBirthData birthData) {
    lastBirthData = birthData;
    return _delegate.getPlanets(birthData);
  }

  @override
  Future<KundaliTimingData> getTiming(
    KundaliBirthData birthData, {
    DateTime? asOf,
  }) {
    lastBirthData = birthData;
    return _delegate.getTiming(birthData, asOf: asOf);
  }
}
