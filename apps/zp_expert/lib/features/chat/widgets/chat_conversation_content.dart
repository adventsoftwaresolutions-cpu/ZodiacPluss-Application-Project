import 'package:flutter/material.dart';

import '../../../shared/widgets/top_scroll_fade.dart';
import '../data/models/chat_conversation_model.dart';
import '../data/models/session_summary_model.dart';
import '../data/provider/chat_conversation_provider.dart';
import 'chat_conversation_banner.dart';
import 'chat_conversation_header.dart';
import 'chat_message_composer.dart';
import 'chat_message_list.dart';
import 'session_summary_sheet.dart';
import '../../call_room/data/models/call_room_model.dart';
import '../../call_room/widgets/call_room_join_card.dart';

class ChatConversationContent extends StatefulWidget {
  const ChatConversationContent({
    required this.conversation,
    required this.controller,
    this.promptSessionSummary = false,
    this.callRoom,
    this.onJoinCallRoom,
    super.key,
  });

  final ChatConversationModel conversation;
  final ChatConversationController controller;
  final bool promptSessionSummary;
  final CallRoomModel? callRoom;
  final VoidCallback? onJoinCallRoom;

  @override
  State<ChatConversationContent> createState() =>
      _ChatConversationContentState();
}

class _ChatConversationContentState extends State<ChatConversationContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollToLatest();
    if (widget.promptSessionSummary &&
        widget.conversation.needsSessionSummary) {
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        if (mounted) _openSummaryForm();
      });
    }
  }

  @override
  void didUpdateWidget(covariant ChatConversationContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conversation.messages.length !=
        widget.conversation.messages.length) {
      _scrollToLatest();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: ChatConversationHeader(
              conversation: widget.conversation,
              onBackTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          const SizedBox(height: 12),
          if (widget.callRoom != null &&
              widget.onJoinCallRoom != null) ...<Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CallRoomJoinCard(
                room: widget.callRoom!,
                onJoin: widget.onJoinCallRoom!,
                compact: true,
              ),
            ),
            const SizedBox(height: 10),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ChatConversationBanner(
              conversation: widget.conversation,
              onFillSummary: () => _openSummaryForm(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
              ),
              child: TopScrollFade(
                fadeExtent: 18,
                child: ChatMessageList(
                  controller: _scrollController,
                  conversation: widget.conversation,
                  onEditSummary: _openSummaryForm,
                ),
              ),
            ),
          ),
          ChatMessageComposer(
            onSendText: widget.controller.sendText,
            onSendDocument: widget.controller.sendDocument,
            messageSendingEnabled: !widget.conversation.isPsychologist,
            documentSendingEnabled: !widget.conversation.isPsychologist,
          ),
        ],
      );

  Future<void> _openSummaryForm([SessionSummaryModel? summary]) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (BuildContext context) => SessionSummarySheet(
        conversation: widget.conversation,
        summary: summary,
        onSave: ({
          required String presentingConcern,
          required String summaryNote,
          required String homework,
          required List<RecommendedExercise> exercises,
        }) =>
            widget.controller.saveSessionSummary(
          presentingConcern: presentingConcern,
          summaryNote: summaryNote,
          homework: homework,
          exercises: exercises,
          summaryToEdit: summary,
        ),
      ),
    );
  }
}
