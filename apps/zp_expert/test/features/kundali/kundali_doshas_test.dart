import 'package:flutter_test/flutter_test.dart';
import 'package:zp_core/zp_core.dart';

void main() {
  test('stub returns only the supported Dosha calculations', () async {
    final data = await const StubKundaliDoshasRepository().getDoshas();

    expect(data.mangal.hasDosha, isTrue);
    expect(data.mangal.type, 'Mild');
    expect(data.kaalSarp.hasDosha, isFalse);
    expect(data.papaSamyam.totalPoints, 2.75);
    expect(data.papaSamyam.detectedPlacementCount, 3);
    expect(data.detectedDoshaCount, 1);
  });

  test('Dosha data survives a JSON round trip', () async {
    final data = await const StubKundaliDoshasRepository().getDoshas();

    final restored = KundaliDoshasData.fromJson(data.toJson());

    expect(restored.mangal.name, data.mangal.name);
    expect(restored.mangal.exceptions, data.mangal.exceptions);
    expect(restored.kaalSarp.hasDosha, data.kaalSarp.hasDosha);
    expect(restored.papaSamyam.totalPoints, data.papaSamyam.totalPoints);
    expect(
      restored.papaSamyam.detectedPlacementCount,
      data.papaSamyam.detectedPlacementCount,
    );
  });
}
