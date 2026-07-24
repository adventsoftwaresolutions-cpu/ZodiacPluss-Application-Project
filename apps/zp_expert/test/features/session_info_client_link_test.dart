import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/session/data/models/session_history_model.dart';
import 'package:zp_expert/features/session/widgets/session_overview_card.dart';

void main() {
  testWidgets('client name in session detail invokes client history action',
      (WidgetTester tester) async {
    int tapCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SessionOverviewCard(
            detail: _detail,
            onClientTap: () => tapCount++,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Vartika Kaur'));

    expect(tapCount, 1);
  });
}

final SessionDetailModel _detail = SessionDetailModel(
  session: SessionHistoryModel(
    id: 'session-1',
    type: SessionType.voice,
    durationMinutes: 20,
    startedAt: DateTime(2026, 7, 19, 10),
    earnings: 500,
  ),
  client: const SessionPerson(
    id: 'client-vartika',
    name: 'Vartika Kaur',
    role: 'Client',
    avatarAsset: 'assets/images/dp.jpg',
  ),
  expert: const SessionPerson(
    id: 'expert-1',
    name: 'Expert',
    role: 'Astrologer',
    avatarAsset: 'assets/images/dp.jpg',
  ),
  status: 'completed',
  grossAmount: 500,
  tax: 0,
  platformFee: 0,
  bonus: 0,
  userConcern: '',
  presentingConcern: '',
  homework: '',
  exercise: '',
  attachmentName: '',
  attachmentSize: '',
  recordingDuration: '',
);
