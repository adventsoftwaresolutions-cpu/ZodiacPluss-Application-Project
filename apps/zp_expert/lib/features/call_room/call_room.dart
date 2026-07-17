import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_routes.dart';
import 'data/models/call_room_model.dart';
import 'data/provider/call_room_provider.dart';
import 'widgets/call_room_content.dart';

class CallRoomPage extends ConsumerWidget {
  const CallRoomPage({required this.roomId, super.key});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CallSessionState> session =
        ref.watch(callSessionProvider(roomId));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: session.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => _CallRoomError(
            onBack: () => context.pop(),
          ),
          data: (CallSessionState data) => CallRoomContent(
            session: data,
            onToggleMute: () =>
                ref.read(callSessionProvider(roomId).notifier).toggleMute(),
            onToggleSpeaker: () =>
                ref.read(callSessionProvider(roomId).notifier).toggleSpeaker(),
            onToggleVideo: () =>
                ref.read(callSessionProvider(roomId).notifier).toggleVideo(),
            onMessage: () => context.push(
              ExpertRoutes.chatConversationFor(data.room.threadId),
            ),
            onEndCall: () =>
                ref.read(callSessionProvider(roomId).notifier).endCall(),
            onLeave: () => context.pop(),
          ),
        ),
      ),
    );
  }
}

class _CallRoomError extends StatelessWidget {
  const _CallRoomError({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.wifi_off_rounded, size: 48),
              const SizedBox(height: 12),
              const Text('Unable to join this consultation room.'),
              const SizedBox(height: 12),
              FilledButton(onPressed: onBack, child: const Text('Go back')),
            ],
          ),
        ),
      );
}
