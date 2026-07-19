import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

import '../data/models/call_room_model.dart';
import '../data/provider/call_media_controller.dart';
import 'call_action_panel.dart';
import 'call_controls.dart';
import 'call_participant_avatar.dart';
import 'call_status_text.dart';

class VideoCallRoomView extends StatelessWidget {
  const VideoCallRoomView({
    required this.session,
    required this.media,
    required this.onToggleMute,
    required this.onToggleSpeaker,
    required this.onToggleVideo,
    required this.onMessage,
    required this.onEndCall,
    required this.onLeave,
    super.key,
  });

  final CallSessionState session;
  final CallMediaState media;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleSpeaker;
  final VoidCallback onToggleVideo;
  final VoidCallback onMessage;
  final VoidCallback onEndCall;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets systemPadding = MediaQuery.paddingOf(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _RemoteVideoSurface(session: session, media: media),
        const _VideoReadabilityOverlay(),
        Positioned(
          left: 18,
          right: 18,
          top: systemPadding.top + 18,
          child: _VideoRoomHeader(session: session),
        ),
        if (session.phase != CallSessionPhase.ended && media.remoteUid != null)
          Positioned(
            left: 18,
            top: systemPadding.top + 78,
            child: _VideoConnectionStatus(session: session),
          ),
        if (session.phase != CallSessionPhase.ended)
          Positioned(
            right: 18,
            top: systemPadding.top + 76,
            child: _LocalVideoPreview(
              isVideoOn: session.isVideoOn,
              media: media,
            ),
          ),
        Positioned(
          left: 16,
          right: 16,
          bottom: systemPadding.bottom + 22,
          child: CallActionPanel(
            ended: session.phase == CallSessionPhase.ended,
            onLeave: onLeave,
            controls: CallControls(
              isMuted: session.isMuted,
              isSpeakerOn: session.isSpeakerOn,
              isVideoOn: session.isVideoOn,
              onToggleMute: onToggleMute,
              onToggleSpeaker: onToggleSpeaker,
              onToggleVideo: onToggleVideo,
              onMessage: onMessage,
              onEndCall: onEndCall,
            ),
          ),
        ),
      ],
    );
  }
}

class _VideoReadabilityOverlay extends StatelessWidget {
  const _VideoReadabilityOverlay();

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.black.withValues(alpha: .38),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withValues(alpha: .6),
              ],
              stops: const <double>[0, .22, .58, 1],
            ),
          ),
        ),
      );
}

class _VideoConnectionStatus extends StatelessWidget {
  const _VideoConnectionStatus({required this.session});

  final CallSessionState session;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.scrim.withValues(alpha: .35),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            CallStatusText(session: session),
          ],
        ),
      );
}

class _RemoteVideoSurface extends StatelessWidget {
  const _RemoteVideoSurface({required this.session, required this.media});

  final CallSessionState session;
  final CallMediaState media;

  @override
  Widget build(BuildContext context) {
    final RtcEngine? engine = media.engine;
    final int? remoteUid = media.remoteUid;
    final String? channelName = media.channelName;
    if (engine != null && remoteUid != null && channelName != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    }
    return AnimatedContainer(
      key: const ValueKey<String>('remote-video-surface'),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Theme.of(context).colorScheme.primary,
            Color.lerp(
              Theme.of(context).colorScheme.primary,
              Colors.black,
              .72,
            )!,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CallParticipantAvatar(
              name: session.room.clientName,
              radius: 54,
              animate: session.phase != CallSessionPhase.ended,
            ),
            const SizedBox(height: 16),
            Text(
              session.room.clientName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 7),
            CallStatusText(session: session),
          ],
        ),
      ),
    );
  }
}

class _VideoRoomHeader extends StatelessWidget {
  const _VideoRoomHeader({required this.session});

  final CallSessionState session;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.scrim.withValues(alpha: .28),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: .18),
          ),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.lock_rounded,
              size: 16, color: Theme.of(context).colorScheme.onPrimary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Private video consultation',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (session.room.paidMinutes > 0)
            Text(
              '${session.room.paidMinutes} min paid',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
        ]),
      );
}

class _LocalVideoPreview extends StatelessWidget {
  const _LocalVideoPreview({required this.isVideoOn, required this.media});

  final bool isVideoOn;
  final CallMediaState media;

  @override
  Widget build(BuildContext context) {
    final RtcEngine? engine = media.engine;
    return Container(
      key: const ValueKey<String>('local-video-preview'),
      width: 92,
      height: 126,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.scrim.withValues(alpha: .68),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: .5),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: .28),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        child: isVideoOn && engine != null && media.localJoined
            ? ClipRRect(
                key: const ValueKey<String>('local-camera-on'),
                borderRadius: BorderRadius.circular(17),
                child: AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ),
              )
            : isVideoOn
                ? Column(
                    key: const ValueKey<String>('local-camera-on'),
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.person_rounded,
                          color: Theme.of(context).colorScheme.onPrimary),
                      const SizedBox(height: 5),
                      Text(
                        'You',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  )
                : Icon(
                    Icons.videocam_off_rounded,
                    key: const ValueKey<String>('local-camera-off'),
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
      ),
    );
  }
}
