import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/kundali_birth_data.dart';
import '../models/kundali_chart_model.dart';
import 'kundali_repository_provider.dart';

final kundaliChartSelectionProvider = StateNotifierProvider.autoDispose<
    KundaliChartSelectionNotifier, KundaliChartRequest>(
  (ref) => KundaliChartSelectionNotifier(),
);

final kundaliChartProvider = FutureProvider.autoDispose
    .family<KundaliChartData, KundaliChartQuery>((ref, query) {
  return ref
      .watch(kundaliRepositoryProvider)
      .getChart(query.birthData, query.chart);
});

class KundaliChartSelectionNotifier extends StateNotifier<KundaliChartRequest> {
  KundaliChartSelectionNotifier()
      : super(
          const KundaliChartRequest(
            section: KundaliChartSection.lagna,
            style: KundaliChartStyle.northIndian,
          ),
        );

  void selectSection(KundaliChartSection section) {
    state = KundaliChartRequest(
      section: section,
      style: state.style,
      division: state.division,
    );
  }

  void selectStyle(KundaliChartStyle style) {
    state = KundaliChartRequest(
      section: state.section,
      style: style,
      division: state.division,
    );
  }

  void selectDivision(KundaliDivision division) {
    state = KundaliChartRequest(
      section: KundaliChartSection.divisional,
      style: state.style,
      division: division,
    );
  }
}
