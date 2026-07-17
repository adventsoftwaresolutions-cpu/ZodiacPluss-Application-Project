import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/kundali/data/models/kundali_chart_model.dart';
import 'package:zp_expert/features/kundali/kundali.dart';
import 'package:zp_expert/features/kundali/widgets/kundali_chart_reveal.dart';
import 'package:zp_expert/features/kundali/widgets/kundali_loading_skeleton.dart';
import 'package:zp_expert/shared/widgets/shimmer_box.dart';

void main() {
  testWidgets('switches chart type, chart style, and divisional chart',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: KundaliPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Birth chart · D1'), findsOneWidget);
    expect(find.text('Planet Short Forms'), findsOneWidget);

    await tester.tap(find.text('Navamsa'));
    await tester.pumpAndSettle();
    expect(find.text('Marriage and inner strength · D9'), findsOneWidget);

    await tester.tap(find.text('South Indian'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Navamsa South Indian Kundali chart'),
        findsOneWidget);

    await tester.tap(find.text('Divisional'));
    await tester.pumpAndSettle();
    expect(find.text('D10'), findsAtLeastNWidgets(1));
    expect(find.text('Dashamsa'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('D7'));
    await tester.pumpAndSettle();
    expect(find.text('Focused divisional analysis'), findsOneWidget);
  });

  testWidgets('renders the animated shimmer loading state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: KundaliLoadingSkeleton()),
        ),
      ),
    );

    expect(find.byType(ShimmerBox), findsAtLeastNWidgets(6));
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens the horizontally scrollable planets page', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: KundaliPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Planets'));
    await tester.pumpAndSettle();

    expect(find.text('Planetary Strengths'), findsOneWidget);
    expect(find.text('Naksh Lord'), findsOneWidget);
    expect(find.text('House'), findsOneWidget);
    expect(find.textContaining('not full Shadbala'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens timing with current periods and Sade Sati',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: KundaliPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Timing'));
    await tester.pumpAndSettle();

    expect(find.text('Current Dasha'), findsOneWidget);
    expect(find.text('Venus Mahadasha'), findsAtLeastNWidgets(1));
    expect(find.text('Jupiter Antardasha'), findsAtLeastNWidgets(1));
    expect(find.text('Mahadasha Timeline'), findsOneWidget);
    expect(find.text('Sade Sati'), findsOneWidget);
    expect(find.text('Rising phase'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens supported Dosha analysis and calculation details',
      (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: KundaliPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Doshas'));
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpAndSettle();

    expect(find.text('Dosha Analysis'), findsOneWidget);
    expect(find.text('Mangal Dosha'), findsOneWidget);
    expect(find.text('Kaal Sarp Dosha'), findsOneWidget);
    expect(find.text('Papa Samyam'), findsOneWidget);
    expect(find.text('Calculated total'), findsOneWidget);
    expect(find.text('Mild'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('dosha-detected-count')),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
    expect(
        find.textContaining('Other doshas are not inferred'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.text('Calculation details'));
    await tester.tap(find.text('Calculation details'));
    await tester.pumpAndSettle();
    expect(find.textContaining('maturity age'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('animates the Kundali structure before revealing its SVG',
      (tester) async {
    const svg = '''
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
        <rect width="100" height="100" fill="white" />
      </svg>
    ''';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox.square(
            dimension: 260,
            child: KundaliChartReveal(
              svg: svg,
              style: KundaliChartStyle.northIndian,
              semanticsLabel: 'Animated Kundali chart',
            ),
          ),
        ),
      ),
    );

    final reveal = find.byType(KundaliChartReveal);
    final opacityFinder = find.descendant(
      of: reveal,
      matching: find.byType(Opacity),
    );
    final initialOpacities = tester
        .widgetList<Opacity>(opacityFinder)
        .map((widget) => widget.opacity)
        .toList();

    await tester.pump(const Duration(milliseconds: 600));

    final animatedOpacities = tester
        .widgetList<Opacity>(opacityFinder)
        .map((widget) => widget.opacity)
        .toList();
    expect(animatedOpacities, isNot(equals(initialOpacities)));
    expect(find.bySemanticsLabel('Animated Kundali chart'), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
