import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/home/data/availability_controller.dart';
import 'package:zp_expert/features/home/data/availability_repository.dart';
import 'package:zp_expert/features/home/data/availability_status.dart';
import 'package:zp_expert/features/home/home.dart';
import 'package:zp_expert/features/wallet/wallet.dart';
import 'package:zp_expert/shared/widgets/glass_top_bar.dart';

void main() {
  testWidgets('home glass top bar stays outside its scroll view',
      (WidgetTester tester) async {
    await _pumpPage(
      tester,
      const HomePage(),
      overrides: <Override>[
        availabilityControllerProvider.overrideWith(
          (Ref ref) => _OnlineAvailabilityController(),
        ),
      ],
    );

    expect(find.byType(GlassTopBar), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(SingleChildScrollView),
        matching: find.byType(GlassTopBar),
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
    await _disposePage(tester);
  });

  testWidgets('wallet glass top bar stays outside its scroll view',
      (WidgetTester tester) async {
    await _pumpPage(tester, const WalletPage());

    expect(find.byType(GlassTopBar), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(CustomScrollView),
        matching: find.byType(GlassTopBar),
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
    await _disposePage(tester);
  });
}

Future<void> _pumpPage(
  WidgetTester tester,
  Widget page, {
  List<Override> overrides = const <Override>[],
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(800, 1200);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(home: page),
    ),
  );
}

class _OnlineAvailabilityController extends AvailabilityController {
  _OnlineAvailabilityController() : super(_ImmediateAvailabilityRepository()) {
    state = AvailabilityStatus.online();
  }
}

class _ImmediateAvailabilityRepository implements AvailabilityRepository {
  @override
  Future<void> setAvailability({required bool online}) async {}
}

Future<void> _disposePage(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 2));
}
