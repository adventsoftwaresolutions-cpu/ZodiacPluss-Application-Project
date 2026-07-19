import 'package:flutter/material.dart';

import '../data/models/call_room_model.dart';
import '../data/provider/call_media_controller.dart';
import 'audio_call_room_view.dart';
import 'video_call_room_view.dart';

class CallRoomContent extends StatelessWidget {
  const CallRoomContent({
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
