import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/auth/auth.dart';
import 'package:zp_expert/features/auth/widgets/auth_blob_background.dart';
import 'package:zp_expert/features/auth/widgets/otp_box.dart';
import 'package:zp_expert/themes/app_themes.dart';

void main() {
  testWidgets('animated glass background remains behind login and OTP',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 760);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(theme: AppThemes.light, home: const AuthPage()),
    );
    await tester.pump();

    expect(find.byType(AuthBlobBackground), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('auth-glass-panel')),
      findsOneWidget,
    );
    expect(find.text('Continue'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.enterText(find.byType(TextField).first, '9876543210');
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Verify OTP'), findsWidgets);
    expect(find.byType(OtpBox), findsNWidgets(4));
    expect(
      find.byKey(const ValueKey<String>('auth-glass-panel')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    final Finder otpFields = find.byType(TextField);
    await tester.enterText(otpFields.at(0), '1');
    await tester.pump();
    await tester.enterText(otpFields.at(1), '2');
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();
    final TextField secondOtpField = tester.widget<TextField>(otpFields.at(1));
    expect(secondOtpField.focusNode!.hasFocus, isTrue);
    expect(secondOtpField.controller!.selection,
        const TextSelection(baseOffset: 0, extentOffset: 1));

    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();
    expect(secondOtpField.controller!.text, isEmpty);
    expect(
        tester.widget<TextField>(otpFields.at(0)).focusNode!.hasFocus, isTrue);
  });
}
