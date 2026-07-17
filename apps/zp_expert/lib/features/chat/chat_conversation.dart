import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/gradient_page.dart';
import 'data/models/chat_conversation_model.dart';
import 'data/provider/chat_conversation_provider.dart';
import 'widgets/chat_conversation_content.dart';
import '../call_room/data/models/call_room_model.dart';
import '../call_room/data/provider/call_room_provider.dart';
import '../../navigation/app_routes.dart';
import 'package:go_router/go_router.dart';

class ChatConversationPage extends ConsumerWidget {
  const ChatConversationPage({
    required this.threadId,
    this.promptSessionSummary = false,
    super.key,
  });

  final String threadId;
  final bool promptSessionSummary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ChatConversationModel> conversation =
        ref.watch(chatConversationProvider(threadId));
    final List<CallRoomModel> readyRooms =
        ref.watch(incomingCallRoomsProvider).valueOrNull ??
            const <CallRoomModel>[];
    CallRoomModel? readyRoom;
    for (final CallRoomModel room in readyRooms) {
      if (room.threadId == threadId) {
        readyRoom = room;
        break;
      }
    }
    return GradientPage(
      child: SafeArea(
        bottom: false,
        child: conversation.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (Object error, StackTrace stackTrace) => _ConversationError(
            onRetry: () => ref.invalidate(chatConversationProvider(threadId)),
          ),
          data: (ChatConversationModel data) => ChatConversationContent(
            conversation: data,
            controller: ref.read(chatConversationProvider(threadId).notifier),
            promptSessionSummary: promptSessionSummary,
            onViewKundali: () => context.push(ExpertRoutes.kundali),
            callRoom: readyRoom,
            onJoinCallRoom: readyRoom == null
                ? null
                : () => context.push(
                      ExpertRoutes.callRoomFor(readyRoom!.id),
                    ),
          ),
        ),
      ),
    );
  }
}

class _ConversationError extends StatelessWidget {
  const _ConversationError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.chat_bubble_outline_rounded, size: 44),
                const SizedBox(height: 12),
                const Text('Unable to load this conversation.'),
                const SizedBox(height: 8),
                TextButton(onPressed: onRetry, child: const Text('Try again')),
              ],
            ),
          ),
        ),
      );
}
