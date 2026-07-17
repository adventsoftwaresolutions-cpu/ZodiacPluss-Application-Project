import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/kundali/data/models/kundali_chart_model.dart';

void main() {
  test('chart request maps selections to Prokerala query values', () {
    const request = KundaliChartRequest(
      section: KundaliChartSection.divisional,
      style: KundaliChartStyle.southIndian,
      division: KundaliDivision.saptamsa,
    );

    expect(request.toJson(), {
      'chart_type': 'saptamsa',
      'chart_style': 'south-indian',
      'format': 'svg',
    });
  });
}
