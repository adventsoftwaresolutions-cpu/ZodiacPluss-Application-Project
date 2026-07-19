import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:zp_expert/features/verification/data/provider/verification_form_provider.dart';
import 'package:zp_expert/features/verification/verification.dart';
import 'package:zp_expert/features/verification/widgets/astrology_background_card.dart';
import 'package:zp_expert/features/verification/widgets/education_experience_card.dart';
import 'package:zp_expert/features/verification/widgets/specialization_card.dart';
import 'package:zp_expert/navigation/app_routes.dart';
import 'package:zp_expert/shared/data/expert_profile.dart';

void main() {
  testWidgets('astrologer follows a tailored multi-step verification path',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);
    final VerificationFormController controller =
        container.read(verificationFormProvider.notifier);
    controller.updateBasicInfo(
      fullName: 'Arjun Mehta',
      email: 'arjun@example.com',
      address: 'Jaipur',
      gender: 'Male',
      dateOfBirth: DateTime(1988, 8, 20),
    );
    controller.toggleLanguage('Hindi');
    controller.setProfilePhoto('Camera photo selected');

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: VerificationPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 4'), findsOneWidget);
    expect(find.text('Apply to become an expert'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('verification-step-lottie')),
      findsOneWidget,
    );
    expect(find.text('Start with a friendly photo'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    final LottieBuilder stepLottie = tester.widget<LottieBuilder>(
      find.byKey(const ValueKey<String>('verification-step-lottie')),
    );
    expect(stepLottie.controller!.value, closeTo(.25, .001));
    expect(find.text('Choose your expert path'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(
      find.byKey(const ValueKey<String>('verification-step-target-0')),
    );
    await tester.pumpAndSettle();
    expect(stepLottie.controller!.value, closeTo(0, .001));
    expect(find.text('Step 1 of 4'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Astrologer'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    controller.updateProfessionalInfo(availability: 'Part Time');
    controller.setOtherPlatform(false);
    controller.setDailyContributionHours(4);
    await tester.pump();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(container.read(verificationFormProvider).form.profession,
        ExpertRole.astrologer);
    expect(find.text('Your Experience'), findsOneWidget);
    expect(find.text('Your astrology journey'), findsOneWidget);
    expect(find.text('Vedic Astrology'), findsOneWidget);
    expect(find.text('Professional Qualification'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'skip and logout leave verification through their intended routes',
      (WidgetTester tester) async {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);
    final GoRouter router = GoRouter(
      initialLocation: ExpertRoutes.verification,
      routes: <RouteBase>[
        GoRoute(
          path: ExpertRoutes.verification,
          builder: (BuildContext context, GoRouterState state) =>
              const VerificationPage(),
        ),
        GoRoute(
          path: ExpertRoutes.home,
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('Home destination')),
        ),
        GoRoute(
          path: ExpertRoutes.auth,
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('Auth destination')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('verification-skip-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('verification-logout-button')),
      findsOneWidget,
    );
    final TextButton skipButton = tester.widget<TextButton>(
      find.byKey(const ValueKey<String>('verification-skip-button')),
    );
    expect(skipButton.style!.backgroundColor!.resolve(<WidgetState>{}),
        Colors.white);

    await tester.tap(
      find.byKey(const ValueKey<String>('verification-skip-button')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Home destination'), findsOneWidget);

    router.go(ExpertRoutes.verification);
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey<String>('verification-logout-button')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Auth destination'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final (String, Widget) card in <(String, Widget)>[
    ('experience', const VerificationEducationExperienceCard()),
    ('astrology background', const AstrologyBackgroundCard()),
    ('specializations', const SpecializationCard()),
  ]) {
    testWidgets('${card.$1} card fits a narrow astrologer layout',
        (WidgetTester tester) async {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(verificationFormProvider.notifier)
          .setProfession(ExpertRole.astrologer);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 354,
                  child: SingleChildScrollView(child: card.$2),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
