import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/call_room/call_room.dart';
import 'package:zp_expert/features/call_room/data/models/call_room_model.dart';
import 'package:zp_expert/features/call_room/data/provider/call_room_provider.dart';
import 'package:zp_expert/features/call_room/data/provider/call_media_controller.dart';
import 'package:zp_expert/features/call_room/data/repository/call_room_repository.dart';
import 'package:zp_expert/features/call_room/widgets/call_room_content.dart';
import 'package:zp_expert/shared/data/expert_profile.dart';
import 'package:zp_expert/shared/data/expert_profile_repository.dart';

void main() {
  test('backend consultation payload maps to a funded video room', () {
    final CallRoomModel room = CallRoomModel.fromJson(const <String, dynamic>{
      'id': 'room-1',
      'mode': 'video',
      'state': 'scheduled',
      'user': <String, dynamic>{
        'id': 'client-1',
        'displayName': 'Aditi',
      },
      'ratePerMinutePaise': 6000,
      'fundedAmountPaise': 12000,
      'requestExpiresAt': '2026-07-18T12:00:00.000Z',
    });

    expect(room.type, CallRoomType.video);
    expect(room.clientName, 'Aditi');
    expect(room.paidMinutes, 2);
  });

  test('backend Agora envelope maps nested credentials', () {
    final AgoraCredentials credentials =
        AgoraCredentials.fromJson(const <String, dynamic>{
      'credentials': <String, dynamic>{
        'appId': 'app-id',
        'channelName': 'room-channel',
        'uid': 42,
        'token': 'rtc-token',
        'self': <String, dynamic>{'displayName': 'Shreya'},
        'remote': <String, dynamic>{'displayName': 'Aditi'},
      },
    });

    expect(credentials.channelName, 'room-channel');
    expect(credentials.remoteDisplayName, 'Aditi');
  });

  test('joining keeps the live room available for rejoin', () async {
    final _ImmediateCallRoomRepository repository =
        _ImmediateCallRoomRepository(clientPresent: true);
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        callRoomRepositoryProvider.overrideWithValue(repository),
        callMediaProvider.overrideWith(
          (Ref ref, String roomId) =>
              _ImmediateCallMediaController(clientPresent: true),
        ),
        expertProfileProvider.overrideWith((Ref ref) async => _profile()),
      ],
    );
    addTearDown(container.dispose);

    expect(
        await container.read(incomingCallRoomsProvider.future), hasLength(1));
    final CallSessionState session =
        await container.read(callSessionProvider('room-1').future);

    expect(session.phase, CallSessionPhase.connected);
    final List<CallRoomModel> active =
        container.read(incomingCallRoomsProvider).valueOrNull!;
    expect(active, hasLength(1));
    expect(active.single.isLive, isTrue);
    expect(repository.acceptedRoomId, 'room-1');
  });

  test('rejoining a live room does not accept it again', () async {
    final _ImmediateCallRoomRepository repository =
        _ImmediateCallRoomRepository(clientPresent: true, roomState: 'live');
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        callRoomRepositoryProvider.overrideWithValue(repository),
        callMediaProvider.overrideWith(
          (Ref ref, String roomId) =>
              _ImmediateCallMediaController(clientPresent: true),
        ),
        expertProfileProvider.overrideWith((Ref ref) async => _profile()),
      ],
    );
    addTearDown(container.dispose);

    final CallSessionState session =
        await container.read(callSessionProvider('room-1').future);

    expect(session.room.isLive, isTrue);
    expect(repository.acceptedRoomId, isNull);
  });

  testWidgets('retry reuses a valid media controller after a join failure',
      (WidgetTester tester) async {
    final _ImmediateCallRoomRepository repository =
        _ImmediateCallRoomRepository(clientPresent: true, roomState: 'live');
    final _RetryCallMediaController media = _RetryCallMediaController();
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          callRoomRepositoryProvider.overrideWithValue(repository),
          callMediaProvider.overrideWith(
            (Ref ref, String roomId) => media,
          ),
          expertProfileProvider.overrideWith((Ref ref) async => _profile()),
        ],
        child: const MaterialApp(home: CallRoomPage(roomId: 'room-1')),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Unable to join this consultation room.'), findsOneWidget);
    expect(media.joinAttempts, 1);

    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Unable to join this consultation room.'), findsNothing);
    expect(
        find.byKey(const ValueKey<String>('drop-call-button')), findsOneWidget);
    expect(media.joinAttempts, 2);
  });

  test('call controller rejects joining a second active room', () async {
    final _ImmediateCallRoomRepository repository =
        _ImmediateCallRoomRepository(clientPresent: true);
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        callRoomRepositoryProvider.overrideWithValue(repository),
        callMediaProvider.overrideWith(
          (Ref ref, String roomId) =>
              _ImmediateCallMediaController(clientPresent: true),
        ),
        expertProfileProvider.overrideWith((Ref ref) async => _profile()),
      ],
    );
    addTearDown(container.dispose);
    container.read(activeCallRoomIdProvider.notifier).state = 'room-active';

    await expectLater(
      container.read(callSessionProvider('room-1').future),
      throwsA(isA<StateError>()),
    );
    expect(repository.acceptedRoomId, isNull);
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
    expect(find.text('Waiting for client · 0:00'), findsOneWidget);

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
    expect(find.textContaining('min paid'), findsOneWidget);
  });

  testWidgets('expert can manually end an active room',
      (WidgetTester tester) async {
    final _ImmediateCallRoomRepository repository =
        _ImmediateCallRoomRepository(clientPresent: false);
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          callRoomRepositoryProvider.overrideWithValue(repository),
          callMediaProvider.overrideWith(
            (Ref ref, String roomId) =>
                _ImmediateCallMediaController(clientPresent: false),
          ),
          expertProfileProvider.overrideWith((Ref ref) async => _profile()),
        ],
        child: const MaterialApp(home: CallRoomPage(roomId: 'room-1')),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('Waiting for client'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('drop-call-button')));
    await tester.pump();

    expect(find.text('Call ended'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('leave-ended-call-button')),
        findsOneWidget);
    expect(repository.endedRoomId, 'room-1');
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
  String state = 'scheduled',
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
      state: state,
    );

class _ImmediateCallRoomRepository implements CallRoomRepository {
  _ImmediateCallRoomRepository({
    required this.clientPresent,
    this.roomState = 'scheduled',
  });

  final bool clientPresent;
  final String roomState;
  String? acceptedRoomId;
  String? endedRoomId;

  CallRoomModel get room => _room(
        type: CallRoomType.video,
        clientPresent: clientPresent,
        state: roomState,
      );

  @override
  Future<List<CallRoomModel>> fetchActiveRooms() async => <CallRoomModel>[room];

  @override
  Future<CallRoomModel> fetchRoom(String roomId) async => room;

  @override
  Future<CallRoomModel> acceptRoom(String roomId) async {
    acceptedRoomId = roomId;
    return CallRoomModel(
      id: room.id,
      threadId: room.threadId,
      clientId: room.clientId,
      clientName: room.clientName,
      type: room.type,
      paidMinutes: room.paidMinutes,
      clientPresent: room.clientPresent,
      readyAt: room.readyAt,
      queuePosition: room.queuePosition,
      state: 'live',
    );
  }

  @override
  Future<void> declineRoom(String roomId) async {}

  @override
  Future<AgoraCredentials> fetchAgoraCredentials(String roomId) async =>
      const AgoraCredentials(
        appId: 'app-id',
        channelName: 'channel',
        uid: 1,
        token: 'token',
        selfDisplayName: 'Expert',
        remoteDisplayName: 'Client',
      );

  @override
  Future<void> endRoom(String roomId) async => endedRoomId = roomId;

  @override
  Future<void> recordCallEvent(String roomId, String eventType) async {}

  @override
  Stream<ConsultationEvent> watchEvents() =>
      const Stream<ConsultationEvent>.empty();
}

class _ImmediateCallMediaController extends CallMediaController {
  _ImmediateCallMediaController({required this.clientPresent});

  final bool clientPresent;

  @override
  Future<void> join(
    AgoraCredentials credentials, {
    required bool video,
  }) async {
    state = state.copyWith(
      localJoined: true,
      microphoneEnabled: true,
      cameraEnabled: video,
      remoteUid: clientPresent ? 2 : null,
      connection: CallMediaConnection.connected,
    );
  }

  @override
  Future<void> leave() async {
    state = state.copyWith(connection: CallMediaConnection.ended);
  }
}

class _RetryCallMediaController extends CallMediaController {
  int joinAttempts = 0;

  @override
  Future<void> join(
    AgoraCredentials credentials, {
    required bool video,
  }) async {
    joinAttempts += 1;
    if (joinAttempts == 1) {
      throw StateError('Agora was not ready.');
    }
    state = state.copyWith(
      localJoined: true,
      microphoneEnabled: true,
      cameraEnabled: video,
      remoteUid: 2,
      connection: CallMediaConnection.connected,
    );
  }

  @override
  Future<void> leave() async {
    state = const CallMediaState();
  }
}
