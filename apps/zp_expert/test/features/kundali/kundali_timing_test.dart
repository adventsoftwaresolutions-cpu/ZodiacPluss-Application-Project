import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/kundali/data/models/kundali_timing_model.dart';
import 'package:zp_expert/features/kundali/data/repository/kundali_timing_repository.dart';

void main() {
  test('stub resolves current and next Vimshottari periods', () async {
    final timing = await const StubKundaliTimingRepository().getTiming(
      asOf: DateTime(2026, 7, 17),
    );

    expect(timing.currentMahadasha.name, 'Venus');
    expect(timing.currentAntardasha.name, 'Jupiter');
    expect(timing.nextAntardasha?.name, 'Saturn');
    expect(timing.antardashaProgress, inInclusiveRange(0.0, 1.0));
    expect(timing.remainingLabel, isNotEmpty);
    expect(timing.sadeSati.isActive, isTrue);
  });

  test('timing data survives a JSON round trip', () async {
    final timing = await const StubKundaliTimingRepository().getTiming(
      asOf: DateTime(2026, 7, 17),
    );

    final restored = KundaliTimingData.fromJson(timing.toJson());

    expect(restored.currentMahadasha.name, timing.currentMahadasha.name);
    expect(restored.currentAntardasha.name, timing.currentAntardasha.name);
    expect(restored.sadeSati.phase, timing.sadeSati.phase);
    expect(restored.timeline.length, timing.timeline.length);
  });
}
