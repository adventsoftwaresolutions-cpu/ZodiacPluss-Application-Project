import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:zp_expert/features/splash/widgets/blooming_lotus.dart';
import 'package:zp_expert/features/splash/widgets/splash_scene.dart';

void main() {
  testWidgets('splash presents branded assets and blooms before completion',
      (WidgetTester tester) async {
    int completionCount = 0;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: SplashScene(onCompleted: () => completionCount++),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));

    final LottieBuilder logoAnimation =
        tester.widget<LottieBuilder>(find.byType(LottieBuilder));
    expect(logoAnimation.repeat, isFalse);
    expect(find.byType(SvgPicture), findsNWidgets(3));
    expect(find.byKey(const ValueKey<String>('splash-brand-name')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('splash-moon-phase')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('splash-lotus')), findsOneWidget);
    expect(
      tester.getSize(find.byType(BloomingLotus)).width,
      closeTo(276.28, .1),
    );
    final List<Icon> backgroundStars =
        tester.widgetList<Icon>(find.byIcon(Icons.star_rounded)).toList();
    final double largestStarSize = backgroundStars.fold<double>(
      0,
      (double largest, Icon star) =>
          (star.size ?? 0) > largest ? star.size! : largest,
    );
    expect(largestStarSize, 36);

    final Transform earlyBloom = tester.widget<Transform>(
      find.byKey(const ValueKey<String>('lotus-bloom-transform')),
    );
    final double earlyScaleY = earlyBloom.transform.entry(1, 1);

    await tester.pump(const Duration(milliseconds: 1300));
    final Transform openBloom = tester.widget<Transform>(
      find.byKey(const ValueKey<String>('lotus-bloom-transform')),
    );

    expect(openBloom.transform.entry(1, 1), greaterThan(earlyScaleY));
    expect(completionCount, 0);

    await tester.pump(const Duration(milliseconds: 81));
    expect(completionCount, 1);
    expect(tester.takeException(), isNull);
  });
}
