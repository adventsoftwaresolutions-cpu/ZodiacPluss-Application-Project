import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/shared/widgets/sidebar_trigger_button.dart';

void main() {
  testWidgets('sidebar trigger is accessible and forwards taps',
      (WidgetTester tester) async {
    int tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SidebarTriggerButton(onTap: () => tapCount++),
          ),
        ),
      ),
    );

    expect(find.byTooltip('Open sidebar'), findsOneWidget);
    expect(find.byIcon(Icons.menu_open_rounded), findsOneWidget);

    await tester.tap(find.byType(SidebarTriggerButton));
    await tester.pump();

    expect(tapCount, 1);
    expect(tester.takeException(), isNull);
  });
}
