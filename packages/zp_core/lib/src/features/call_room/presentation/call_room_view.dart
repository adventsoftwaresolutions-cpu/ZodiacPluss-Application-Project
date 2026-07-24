import 'package:flutter/material.dart';

import '../data/models/call_room_model.dart';
import '../data/provider/call_media_controller.dart';
import 'widgets/audio_call_room_view.dart';
import 'widgets/video_call_room_view.dart';

/// Content-only call room widget that switches between audio and video views.
///
/// This is a shared widget that does **not** own a [Scaffold], [AppBar], or
/// route. Each consuming app wraps it in its own page-level [Scaffold] and
/// routing setup per `core.md` rules.
class CallRoomView extends StatelessWidget {
  const CallRoomView({
    required this.session,
    this.media = const CallMediaState(),
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
  Widget build(BuildContext context) => switch (session.room.type) {
        CallRoomType.audio => AudioCallRoomView(
            session: session,
            onToggleMute: onToggleMute,
            onToggleSpeaker: onToggleSpeaker,
            onMessage: onMessage,
            onEndCall: onEndCall,
            onLeave: onLeave,
          ),
        CallRoomType.video => VideoCallRoomView(
            session: session,
            media: media,
            onToggleMute: onToggleMute,
            onToggleSpeaker: onToggleSpeaker,
            onToggleVideo: onToggleVideo,
            onMessage: onMessage,
            onEndCall: onEndCall,
            onLeave: onLeave,
          ),
      };
}
