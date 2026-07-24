import 'package:flutter_test/flutter_test.dart';
import 'package:zp_core/zp_core.dart';

void main() {
  test('chart request maps selections to engine-neutral calculation keys', () {
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
