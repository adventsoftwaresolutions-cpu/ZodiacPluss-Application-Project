import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/call_room/call_room.dart';
import 'package:zp_expert/features/call_room/data/models/call_room_model.dart';
import 'package:zp_expert/features/call_room/data/provider/call_room_provider.dart';
import 'package:zp_expert/features/call_room/data/repository/call_room_repository.dart';
import 'package:zp_expert/features/call_room/widgets/call_room_content.dart';
import 'package:zp_expert/shared/data/expert_profile.dart';
import 'package:zp_expert/shared/data/expert_profile_repository.dart';

void main() {
  test('joining a room removes it from the incoming paid-room queue', () async {
    final _ImmediateCallRoomRepository repository =
        _ImmediateCallRoomRepository(clientPresent: true);
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        callRoomRepositoryProvider.overrideWithValue(repository),
        expertProfileProvider.overrideWith((Ref ref) async => _profile()),
      ],
    );
    addTearDown(container.dispose);

    expect(
        await container.read(incomingCallRoomsProvider.future), hasLength(1));
    final CallSessionState session =
        await container.read(callSessionProvider('room-1').future);

    expect(session.phase, CallSessionPhase.connected);
    expect(container.read(incomingCallRoomsProvider).valueOrNull, isEmpty);
    expect(repository.joinedRoomId, 'room-1');
  });

  testWidgets('audio and video rooms expose the correct controls',
      (WidgetTester tester) async {
    final CallRoomModel audioRoom = _room(
      type: CallRoomType.audio,
      clientPresent: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CallRoomContent(
            session: CallSessionState(
              room: audioRoom,
              expertRole: ExpertRole.psychologist,
              phase: CallSessionPhase.connected,
            ),
            onToggleMute: () {},
            onToggleSpeaker: () {},
            onToggleVideo: () {},
            onMessage: () {},
            onEndCall: () {},
            onLeave: () {},
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey<String>('toggle-video-button')),
        findsNothing);
    expect(find.byKey(const ValueKey<String>('toggle-speaker-button')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('toggle-mute-button')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('call-message-button')),
        findsOneWidget);
    expect(
        find.byKey(const ValueKey<String>('drop-call-button')), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CallRoomContent(
            session: CallSessionState(
              room: _room(
                type: CallRoomType.video,
                clientPresent: false,
              ),
              expertRole: ExpertRole.psychologist,
              phase: CallSessionPhase.waitingForClient,
            ),
            onToggleMute: () {},
            onToggleSpeaker: () {},
            onToggleVideo: () {},
            onMessage: () {},
            onEndCall: () {},
            onLeave: () {},
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey<String>('toggle-video-button')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('remote-video-surface')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('local-video-preview')),
        findsOneWidget);
    expect(find.text('Waiting for client · 1:00'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CallRoomContent(
            session: CallSessionState(
              room: audioRoom,
              expertRole: ExpertRole.astrologer,
              phase: CallSessionPhase.connected,
            ),
            onToggleMute: () {},
            onToggleSpeaker: () {},
            onToggleVideo: () {},
            onMessage: () {},
            onEndCall: () {},
            onLeave: () {},
          ),
        ),
      ),
    );
    expect(find.textContaining('min paid'), findsNothing);
  });

  testWidgets('empty room automatically ends after one minute',
      (WidgetTester tester) async {
    final _ImmediateCallRoomRepository repository =
        _ImmediateCallRoomRepository(clientPresent: false);
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          callRoomRepositoryProvider.overrideWithValue(repository),
          expertProfileProvider.overrideWith((Ref ref) async => _profile()),
        ],
        child: const MaterialApp(home: CallRoomPage(roomId: 'room-1')),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.textContaining('Waiting for client'), findsOneWidget);

    await tester.pump(const Duration(seconds: 60));
    await tester.pump();

    expect(find.text('Room closed · client did not join'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('leave-ended-call-button')),
        findsOneWidget);
    expect(repository.leftRoomId, 'room-1');
  });
}

ExpertProfile _profile() => const ExpertProfile(
      id: 'expert-1',
      name: 'Expert',
      role: ExpertRole.psychologist,
      avatarUrl: '',
      isVerified: true,
    );

CallRoomModel _room({
  required CallRoomType type,
  required bool clientPresent,
}) =>
    CallRoomModel(
      id: 'room-1',
      threadId: 'thread-psy-1',
      clientId: 'client-101',
      clientName: 'Ananya Singh',
      type: type,
      paidMinutes: 20,
      clientPresent: clientPresent,
      readyAt: DateTime(2026, 7, 17, 10),
      queuePosition: 1,
    );

class _ImmediateCallRoomRepository implements CallRoomRepository {
  _ImmediateCallRoomRepository({required this.clientPresent});

  final bool clientPresent;
  String? joinedRoomId;
  String? leftRoomId;

  CallRoomModel get room => _room(
        type: CallRoomType.video,
        clientPresent: clientPresent,
      );

  @override
  Future<List<CallRoomModel>> fetchReadyRooms(ExpertRole expertRole) async =>
      <CallRoomModel>[room];

  @override
  Future<CallRoomModel> fetchRoom(String roomId) async => room;

  @override
  Future<void> joinRoom(String roomId) async => joinedRoomId = roomId;

  @override
  Future<void> leaveRoom(String roomId) async => leftRoomId = roomId;

  @override
  Future<void> setMuted(String roomId, {required bool muted}) async {}

  @override
  Future<void> setSpeakerEnabled(
    String roomId, {
    required bool enabled,
  }) async {}

  @override
  Future<void> setVideoEnabled(
    String roomId, {
    required bool enabled,
  }) async {}
}
