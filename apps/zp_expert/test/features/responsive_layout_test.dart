import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:zp_expert/features/home/data/availability_status.dart';
import 'package:zp_expert/features/home/data/performance_repository.dart';
import 'package:zp_expert/features/home/data/performance_stats.dart';
import 'package:zp_expert/features/home/data/wallet_repository.dart';
import 'package:zp_expert/features/home/widgets/availability_status_visual.dart';
import 'package:zp_expert/features/home/widgets/performance_card.dart';
import 'package:zp_expert/features/home/widgets/profile_greeting_header.dart';
import 'package:zp_expert/features/home/widgets/wallet_balance_card.dart';
import 'package:zp_expert/features/manage_pricing/data/models/pricing_model.dart';
import 'package:zp_expert/features/manage_pricing/widgets/pricing_header.dart';
import 'package:zp_expert/features/manage_pricing/widgets/pricing_plan_card.dart';
import 'package:zp_expert/features/profile/widgets/profile_media_cards.dart';

void main() {
  testWidgets('home header fits a narrow screen with enlarged text',
      (WidgetTester tester) async {
    await _pumpNarrow(
      tester,
      ProfileGreetingHeader(
        name: 'Dr. Priya Sharma',
        role: 'Psychologist',
        avatarUrl: 'assets/images/dp.jpg',
        isVerified: true,
        status: AvailabilityStatus.online(),
        onNotificationTap: () {},
        onChatTap: () {},
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('home data cards fit a narrow screen with enlarged text',
      (WidgetTester tester) async {
    await _pumpNarrow(
      tester,
      Column(
        children: <Widget>[
          WalletBalanceCard(onCheckStatus: () {}),
          const SizedBox(height: 12),
          PerformanceCard(
            onSessionHistoryTap: () {},
            onTransactionHistoryTap: () {},
            onReviewsTap: () {},
          ),
        ],
      ),
      overrides: <Override>[
        walletBalanceProvider.overrideWith((Ref ref) async => 72000),
        performanceStatsProvider.overrideWith(
          (Ref ref) async => const PerformanceStats(
            earningsToday: 5840,
            averageRating: 4.8,
            responseTime: Duration(minutes: 2, seconds: 25),
            missedSessions: 12,
            cancelledSessions: 3,
          ),
        ),
      ],
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('wallet and yoga views animate compact and expanded heights',
      (WidgetTester tester) async {
    Future<void> pumpVisual({required bool isOnline}) {
      return tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[
            walletBalanceProvider.overrideWith((Ref ref) async => 72000),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 328,
                  child: AvailabilityStatusVisual(
                    isOnline: isOnline,
                    onCheckWalletStatus: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    await pumpVisual(isOnline: false);
    await tester.pump();
    final Size offlineSize =
        tester.getSize(find.byType(AvailabilityStatusVisual));
    expect(tester.takeException(), isNull);

    await pumpVisual(isOnline: true);
    await tester.pump(const Duration(milliseconds: 260));
    final Size transitionSize =
        tester.getSize(find.byType(AvailabilityStatusVisual));
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(milliseconds: 260));
    final Size onlineSize =
        tester.getSize(find.byType(AvailabilityStatusVisual));

    expect(offlineSize.height, 56);
    expect(transitionSize.height, greaterThan(offlineSize.height));
    expect(transitionSize.height, lessThan(onlineSize.height));
    expect(onlineSize.height, 120);
    expect(onlineSize.width, offlineSize.width);
    final Finder yogaBackground = find.byKey(
      const ValueKey<String>('yoga-wrapper-background'),
    );
    expect(
      tester
          .widget<ColoredBox>(
            find.byKey(
              const ValueKey<String>('yoga-wrapper-background-color'),
            ),
          )
          .color,
      const Color(0xFFFFFFE8),
    );
    expect(
      tester.widget<ClipRRect>(yogaBackground).borderRadius,
      const BorderRadius.all(Radius.circular(16)),
    );
    expect(tester.getSize(yogaBackground), onlineSize);
    expect(tester.takeException(), isNull);
  });

  testWidgets('yoga intro hands off to the continuously looping mid marker',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          walletBalanceProvider.overrideWith((Ref ref) async => 72000),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: AvailabilityStatusVisual(
              isOnline: true,
              onCheckWalletStatus: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final LottieBuilder lottie = tester.widget<LottieBuilder>(
      find.byKey(const ValueKey<String>('yoga-lottie-animation')),
    );
    final AnimationController controller =
        lottie.controller! as AnimationController;

    await tester.pump(const Duration(milliseconds: 2700));
    final double firstLoopValue = controller.value;

    expect(controller.isAnimating, isTrue);
    expect(firstLoopValue, inInclusiveRange(59 / 119.99, 1));

    await tester.pump(const Duration(milliseconds: 300));

    expect(controller.isAnimating, isTrue);
    expect(controller.value, inInclusiveRange(59 / 119.99, 1));
    expect(controller.value, isNot(firstLoopValue));
    expect(tester.takeException(), isNull);
  });

  testWidgets('pricing header and controls adapt on a narrow screen',
      (WidgetTester tester) async {
    await _pumpNarrow(
      tester,
      Column(
        children: <Widget>[
          PricingHeader(onBackTap: () {}),
          const SizedBox(height: 16),
          PricingPlanCard(
            plan: const PricingPlan(
              userType: PricingUserType.normal,
              description: 'Flexible pricing for regular clients',
              kind: PricingPlanKind.normal,
              items: <PricingItem>[
                PricingItem(
                  service: PricingService.chat,
                  price: 25,
                  discountPercent: 10,
                ),
              ],
            ),
            onItemChanged: (_, __, ___) {},
          ),
        ],
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('intro replace action remains compact and responsive',
      (WidgetTester tester) async {
    const Key actionKey = ValueKey<String>('intro-upload-action');

    await _pumpNarrow(
      tester,
      const IntroCard(hasIntro: true, onUpload: _ignoreUpload),
    );
    final Size narrowActionSize = tester.getSize(find.byKey(actionKey));

    tester.view.resetDevicePixelRatio();
    tester.view.resetPhysicalSize();
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 420,
              child: IntroCard(hasIntro: true, onUpload: _ignoreUpload),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final Size wideActionSize = tester.getSize(find.byKey(actionKey));

    expect(narrowActionSize, const Size(104, 56));
    expect(wideActionSize, const Size(128, 64));
    expect(tester.takeException(), isNull);
  });

  testWidgets('pricing can be entered directly with the keyboard',
      (WidgetTester tester) async {
    int? enteredPrice;

    await _pumpNarrow(
      tester,
      PricingPlanCard(
        plan: const PricingPlan(
          userType: PricingUserType.normal,
          description: 'Flexible pricing for regular clients',
          kind: PricingPlanKind.normal,
          items: <PricingItem>[
            PricingItem(
              service: PricingService.chat,
              price: 25,
              discountPercent: 10,
            ),
          ],
        ),
        onItemChanged: (_, int? price, __) => enteredPrice = price,
      ),
    );

    await tester.enterText(find.byType(TextField), '42');
    await tester.pump();

    expect(enteredPrice, 42);
  });
}

Future<void> _pumpNarrow(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const <Override>[],
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(320, 900);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 900),
              textScaler: TextScaler.linear(1.3),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _ignoreUpload(String _) async {}
