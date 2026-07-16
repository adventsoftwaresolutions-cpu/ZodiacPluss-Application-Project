import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/home/data/availability_status.dart';
import 'package:zp_expert/features/home/data/performance_repository.dart';
import 'package:zp_expert/features/home/data/performance_stats.dart';
import 'package:zp_expert/features/home/data/wallet_repository.dart';
import 'package:zp_expert/features/home/widgets/performance_card.dart';
import 'package:zp_expert/features/home/widgets/profile_greeting_header.dart';
import 'package:zp_expert/features/home/widgets/wallet_balance_card.dart';
import 'package:zp_expert/features/manage_pricing/data/models/pricing_model.dart';
import 'package:zp_expert/features/manage_pricing/widgets/pricing_header.dart';
import 'package:zp_expert/features/manage_pricing/widgets/pricing_plan_card.dart';

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
