import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/shared/widgets/glass_top_bar.dart';

void main() {
  testWidgets('glass top bar exposes sidebar and header actions',
      (WidgetTester tester) async {
    int notificationTaps = 0;
    int chatTaps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              child: GlassTopBar(
                title: 'Wallet',
                onNotificationTap: () => notificationTaps++,
                onChatTap: () => chatTaps++,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Wallet'), findsOneWidget);
    expect(find.byTooltip('Open sidebar'), findsOneWidget);

    await tester.tap(find.byTooltip('Notifications'));
    await tester.tap(find.byTooltip('Client chats'));

    expect(notificationTaps, 1);
    expect(chatTaps, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('glass top bar replaces sidebar with back affordance',
      (WidgetTester tester) async {
    int backTaps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassTopBar(
            title: 'Reviews',
            onBackTap: () => backTaps++,
            onNotificationTap: () {},
            onChatTap: () {},
          ),
        ),
      ),
    );

    expect(find.byTooltip('Open sidebar'), findsNothing);
    await tester.tap(find.byTooltip('Back'));
    expect(backTaps, 1);
  });
}
