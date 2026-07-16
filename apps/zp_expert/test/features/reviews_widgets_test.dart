import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/reviews/data/models/review_model.dart';
import 'package:zp_expert/features/reviews/reviews.dart';
import 'package:zp_expert/features/reviews/widgets/review_card.dart';
import 'package:zp_expert/features/reviews/widgets/reviews_overview_card.dart';

void main() {
  testWidgets('review action menu exposes report and invokes callback',
      (WidgetTester tester) async {
    bool reportTapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReviewCard(
            review: ExpertReview(
              id: 'review-1',
              clientName: 'Ananya Singh',
              rating: 5,
              comment: 'A thoughtful and helpful session.',
              createdAt: DateTime.now(),
              isReported: false,
            ),
            onReport: () => reportTapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.more_vert_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Report review'), findsOneWidget);

    await tester.tap(find.text('Report review'));
    await tester.pumpAndSettle();
    expect(reportTapped, isTrue);
  });

  testWidgets('review summary and card fit a narrow enlarged-text layout',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 760);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 760),
              textScaler: TextScaler.linear(1.3),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  const ReviewsOverviewCard(
                    averageRating: 4.8,
                    totalReviews: 128,
                  ),
                  const SizedBox(height: 14),
                  ReviewCard(
                    review: ExpertReview(
                      id: 'review-1',
                      clientName: 'A Client With A Long Name',
                      rating: 5,
                      comment:
                          'This is a longer review that should remain readable on a narrow device.',
                      createdAt: DateTime.now(),
                      isReported: false,
                    ),
                    onReport: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('reviews page loads summary and completes report interaction',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: ReviewsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reviews'), findsOneWidget);
    expect(find.text('4.8'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
    expect(find.text('Ananya Singh'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_vert_rounded).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Report review'));
    await tester.pumpAndSettle();
    expect(find.text('Report this review'), findsOneWidget);

    await tester.tap(find.text('Spam or promotional content'));
    await tester.pumpAndSettle();
    expect(find.text('Reported for review'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
