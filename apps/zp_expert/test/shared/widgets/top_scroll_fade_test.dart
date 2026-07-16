import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/shared/widgets/top_scroll_fade.dart';

void main() {
  testWidgets('activates the top fade after vertical scrolling',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TopScrollFade(
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 80, child: Text('Item $index')),
            ),
          ),
        ),
      ),
    );

    TweenAnimationBuilder<double> fade =
        tester.widget<TweenAnimationBuilder<double>>(
      find.byType(TweenAnimationBuilder<double>),
    );
    expect(fade.tween.end, 0);

    await tester.drag(find.byType(ListView), const Offset(0, -240));
    await tester.pump();

    fade = tester.widget<TweenAnimationBuilder<double>>(
      find.byType(TweenAnimationBuilder<double>),
    );
    expect(fade.tween.end, 1);

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
