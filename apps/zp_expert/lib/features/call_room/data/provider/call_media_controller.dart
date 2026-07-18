import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/call_room_model.dart';

enum CallMediaConnection { idle, connecting, connected, reconnecting, ended }

@immutable
class CallMediaState {
  const CallMediaState({
    this.engine,
    this.channelName,
    this.remoteUid,
    this.localJoined = false,
    this.microphoneEnabled = false,
    this.cameraEnabled = false,
    this.connection = CallMediaConnection.idle,
  });

  final RtcEngine? engine;
  final String? channelName;
  final int? remoteUid;
  final bool localJoined;
  final bool microphoneEnabled;
  final bool cameraEnabled;
  final CallMediaConnection connection;

  CallMediaState copyWith({
    RtcEngine? engine,
    String? channelName,
    int? remoteUid,
    bool clearRemoteUid = false,
    bool? localJoined,
    bool? microphoneEnabled,
    bool? cameraEnabled,
    CallMediaConnection? connection,
  }) =>
      CallMediaState(
        engine: engine ?? this.engine,
        channelName: channelName ?? this.channelName,
        remoteUid: clearRemoteUid ? null : (remoteUid ?? this.remoteUid),
        localJoined: localJoined ?? this.localJoined,
        microphoneEnabled: microphoneEnabled ?? this.microphoneEnabled,
        cameraEnabled: cameraEnabled ?? this.cameraEnabled,
        connection: connection ?? this.connection,
      );
}

final StateNotifierProviderFamily<CallMediaController, CallMediaState, String>
    callMediaProvider =
    StateNotifierProvider.family<CallMediaController, CallMediaState, String>(
  (Ref ref, String roomId) => CallMediaController(),
);

class CallMediaController extends StateNotifier<CallMediaState> {
  CallMediaController() : super(const CallMediaState());

  RtcEngine? _engine;
  bool _disposed = false;
  bool _speakerEnabled = true;

  Future<void> join(
    AgoraCredentials credentials, {
    required bool video,
  }) async {
    if (_engine != null) return;
    if (_disposed) {
      throw StateError('The call media session is no longer available.');
    }
    final bool microphoneEnabled =
        (await Permission.microphone.request()).isGranted;
    final bool cameraEnabled =
        video && (await Permission.camera.request()).isGranted;

    state = state.copyWith(
      channelName: credentials.channelName,
      microphoneEnabled: microphoneEnabled,
      cameraEnabled: cameraEnabled,
      connection: CallMediaConnection.connecting,
    );
    final RtcEngine engine = createAgoraRtcEngine();
    _engine = engine;
    await engine.initialize(RtcEngineContext(
      appId: credentials.appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        if (_disposed) return;
        state = state.copyWith(
          engine: engine,
          localJoined: true,
          connection: CallMediaConnection.connected,
        );
        unawaited(_applySpeakerRoute(engine));
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        if (_disposed) return;
        state = state.copyWith(remoteUid: remoteUid);
      },
      onUserOffline: (
        RtcConnection connection,
        int remoteUid,
        UserOfflineReasonType reason,
      ) {
        if (_disposed || state.remoteUid != remoteUid) return;
        state = state.copyWith(clearRemoteUid: true);
      },
      onConnectionStateChanged: (
        RtcConnection connection,
        ConnectionStateType connectionState,
        ConnectionChangedReasonType reason,
      ) {
        if (_disposed) return;
        final CallMediaConnection mediaConnection = switch (connectionState) {
          ConnectionStateType.connectionStateConnecting =>
            CallMediaConnection.connecting,
          ConnectionStateType.connectionStateConnected =>
            CallMediaConnection.connected,
          ConnectionStateType.connectionStateReconnecting =>
            CallMediaConnection.reconnecting,
          ConnectionStateType.connectionStateDisconnected ||
          ConnectionStateType.connectionStateFailed =>
            CallMediaConnection.ended,
        };
        state = state.copyWith(connection: mediaConnection);
      },
    ));
    await engine.enableAudio();
    await engine.setDefaultAudioRouteToSpeakerphone(true);
    if (video) {
      await engine.enableVideo();
    }
    if (cameraEnabled) {
      await engine.startPreview();
    }
    await engine.joinChannel(
      token: credentials.token,
      channelId: credentials.channelName,
      uid: credentials.uid,
      options: ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
        publishMicrophoneTrack: microphoneEnabled,
        publishCameraTrack: cameraEnabled,
        autoSubscribeAudio: true,
        autoSubscribeVideo: video,
      ),
    );
    if (!_disposed) state = state.copyWith(engine: engine);
  }

  Future<bool> setMuted(bool muted) async {
    bool microphoneEnabled = state.microphoneEnabled;
    if (!muted && !microphoneEnabled) {
      microphoneEnabled = (await Permission.microphone.request()).isGranted;
    }
    final bool actualMuted = muted || !microphoneEnabled;
    await _engine?.muteLocalAudioStream(actualMuted);
    state = state.copyWith(microphoneEnabled: microphoneEnabled);
    return actualMuted;
  }

  Future<void> setSpeakerEnabled(bool enabled) async {
    _speakerEnabled = enabled;
    final RtcEngine? engine = _engine;
    if (engine == null || !state.localJoined) return;
    await _applySpeakerRoute(engine);
  }

  Future<void> _applySpeakerRoute(RtcEngine engine) async {
    try {
      await engine.setEnableSpeakerphone(_speakerEnabled);
    } on AgoraRtcException catch (error) {
      // Audio routing is only available after Agora has entered the channel.
      // A route failure must never abort or end the consultation itself.
      debugPrint('Unable to change Agora speaker route: $error');
    }
  }

  Future<bool> setVideoEnabled(bool enabled) async {
    bool cameraEnabled = state.cameraEnabled;
    if (enabled && !cameraEnabled) {
      cameraEnabled = (await Permission.camera.request()).isGranted;
    }
    final bool actualEnabled = enabled && cameraEnabled;
    await _engine?.enableLocalVideo(actualEnabled);
    await _engine?.muteLocalVideoStream(!actualEnabled);
    state = state.copyWith(cameraEnabled: cameraEnabled);
    return actualEnabled;
  }

  Future<void> leave() async {
    final RtcEngine? engine = _engine;
    if (engine == null) return;
    _engine = null;
    if (!_disposed) {
      state = state.copyWith(
        connection: CallMediaConnection.ended,
        localJoined: false,
        clearRemoteUid: true,
      );
    }
    await engine.stopPreview();
    await engine.leaveChannel();
    await engine.release();
  }

  @override
  void dispose() {
    _disposed = true;
    _engine?.leaveChannel();
    _engine?.release();
    _engine = null;
    super.dispose();
  }
}
