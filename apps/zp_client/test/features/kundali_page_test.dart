import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_client/features/kundali/kundali.dart';
import 'package:zp_core/zp_core.dart';

void main() {
  testWidgets('client renders shared Kundali with client-owned page chrome',
      (tester) async {
    final birthData = KundaliBirthData(
      birthDateTimeUtc: DateTime.utc(1996, 8, 22, 10, 15),
      latitude: 12.9716,
      longitude: 77.5946,
      timeZoneId: 'Asia/Kolkata',
      placeName: 'Bengaluru',
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0D4F23),
            ),
          ),
          home: KundaliPage(birthData: birthData),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Kundali'), findsOneWidget);
    expect(find.text('Charts'), findsOneWidget);
    expect(find.text('Birth chart · D1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
