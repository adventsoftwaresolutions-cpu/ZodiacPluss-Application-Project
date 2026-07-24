import '../models/kundali_birth_data.dart';
import '../models/kundali_chart_model.dart';
import '../models/kundali_dosha_model.dart';
import '../models/kundali_planet_model.dart';
import '../models/kundali_timing_model.dart';
import 'kundali_chart_repository.dart';
import 'kundali_doshas_repository.dart';
import 'kundali_planets_repository.dart';
import 'kundali_timing_repository.dart';

/// Stable boundary between Kundali presentation and its calculation engine.
///
/// An API-backed implementation and a future Swiss Ephemeris SDK
/// implementation can both satisfy this contract without changing providers
/// or widgets.
abstract interface class KundaliRepository {
  Future<KundaliChartData> getChart(
    KundaliBirthData birthData,
    KundaliChartRequest request,
  );

  Future<KundaliPlanetsData> getPlanets(KundaliBirthData birthData);

  Future<KundaliTimingData> getTiming(
    KundaliBirthData birthData, {
    DateTime? asOf,
  });

  Future<KundaliDoshasData> getDoshas(KundaliBirthData birthData);
}

/// Local deterministic implementation used until a calculation engine is
/// selected. It preserves the current expert-app data and visual behaviour.
class StubKundaliRepository implements KundaliRepository {
  const StubKundaliRepository({
    this.charts = const StubKundaliChartRepository(),
    this.planets = const StubKundaliPlanetsRepository(),
    this.timing = const StubKundaliTimingRepository(),
    this.doshas = const StubKundaliDoshasRepository(),
  });

  final KundaliChartRepository charts;
  final KundaliPlanetsRepository planets;
  final KundaliTimingRepository timing;
  final KundaliDoshasRepository doshas;

  @override
  Future<KundaliChartData> getChart(
    KundaliBirthData birthData,
    KundaliChartRequest request,
  ) {
    return charts.getChart(request);
  }

  @override
  Future<KundaliPlanetsData> getPlanets(KundaliBirthData birthData) {
    return planets.getPlanets();
  }

  @override
  Future<KundaliTimingData> getTiming(
    KundaliBirthData birthData, {
    DateTime? asOf,
  }) {
    return timing.getTiming(asOf: asOf);
  }

  @override
  Future<KundaliDoshasData> getDoshas(KundaliBirthData birthData) {
    return doshas.getDoshas();
  }
}
