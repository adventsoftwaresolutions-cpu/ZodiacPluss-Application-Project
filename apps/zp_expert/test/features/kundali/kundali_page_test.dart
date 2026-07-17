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
