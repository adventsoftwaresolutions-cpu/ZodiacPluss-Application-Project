import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../themes/app_radius.dart';
import '../data/models/chat_conversation_model.dart';
import '../data/models/session_summary_model.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    required this.controller,
    required this.conversation,
    required this.onEditSummary,
    super.key,
  });

  final ScrollController controller;
  final ChatConversationModel conversation;
  final ValueChanged<SessionSummaryModel> onEditSummary;

  @override
  Widget build(BuildContext context) {
    final List<ChatMessageModel> visibleMessages = conversation.isPsychologist
        ? conversation.messages
            .where((ChatMessageModel message) =>
                message.type == ChatMessageType.sessionSummary)
            .toList()
        : conversation.messages
            .where((ChatMessageModel message) =>
                message.type != ChatMessageType.sessionSummary)
            .toList();
    if (visibleMessages.isEmpty) {
      return _EmptyConversation(controller: controller);
    }
    final String? latestSummaryId =
        conversation.isPsychologist ? visibleMessages.last.id : null;
    return ListView.separated(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 22, 14, 20),
      itemCount: visibleMessages.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final ChatMessageModel message = visibleMessages[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 220 + (index * 35)),
          curve: Curves.easeOutCubic,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (BuildContext context, double value, Widget? child) =>
              Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 10 * (1 - value)),
              child: child,
            ),
          ),
          child: message.type == ChatMessageType.sessionSummary
              ? SessionSummaryChatCard(
                  summary: message.summary!,
                  onEdit: message.id == latestSummaryId
                      ? () => onEditSummary(message.summary!)
                      : null,
                )
              : _MessageBubble(message: message),
        );
      },
    );
  }
}

class _EmptyConversation extends StatelessWidget {
  const _EmptyConversation({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) => ListView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(28, 72, 28, 24),
        children: <Widget>[
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 46,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'No messages yet',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Start the consultation conversation when you are ready.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF637272),
                  height: 1.4,
                ),
          ),
        ],
      );
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    final bool outgoing = message.sender == ChatMessageSender.expert;
    final Color primary = Theme.of(context).colorScheme.primary;
    return Align(
      alignment: outgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .78,
        ),
        padding: const EdgeInsets.fromLTRB(14, 11, 12, 8),
        decoration: BoxDecoration(
          color: outgoing ? primary : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.lg),
            topRight: const Radius.circular(AppRadius.lg),
            bottomLeft: Radius.circular(outgoing ? AppRadius.lg : 4),
            bottomRight: Radius.circular(outgoing ? 4 : AppRadius.lg),
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            if (message.type == ChatMessageType.document)
              _DocumentContent(message: message, outgoing: outgoing)
            else
              Text(
                message.text,
                style: TextStyle(
                  color: outgoing
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                  height: 1.35,
                ),
              ),
            const SizedBox(height: 5),
            Text(
              DateFormat('h:mm a').format(message.sentAt),
              style: TextStyle(
                color: outgoing
                    ? Colors.white.withValues(alpha: .72)
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: .5),
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentContent extends StatelessWidget {
  const _DocumentContent({required this.message, required this.outgoing});

  final ChatMessageModel message;
  final bool outgoing;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: outgoing ? .18 : .75),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              Icons.description_outlined,
              color: outgoing
                  ? Colors.white
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              message.documentName ?? 'Document',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: outgoing ? Colors.white : null,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
}

class SessionSummaryChatCard extends StatelessWidget {
  const SessionSummaryChatCard({
    required this.summary,
    this.onEdit,
    super.key,
  });

  final SessionSummaryModel summary;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) => Container(
        key: const ValueKey<String>('session-summary-card'),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .18),
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SummaryHeader(summary: summary, onEdit: onEdit),
            const Divider(height: 24),
            _SummarySection(
              icon: Icons.person_outline_rounded,
              label: 'Client concern',
              value: summary.userConcern,
            ),
            _SummarySection(
              icon: Icons.psychology_outlined,
              label: 'Presenting concern',
              value: summary.presentingConcern,
            ),
            if (summary.summaryNote.trim().isNotEmpty)
              _SummarySection(
                icon: Icons.notes_rounded,
                label: 'Session note',
                value: summary.summaryNote,
              ),
            if (summary.homework.trim().isNotEmpty)
              _SummarySection(
                icon: Icons.task_alt_rounded,
                label: 'Homework',
                value: summary.homework,
              ),
            if (summary.exercises.isNotEmpty)
              _ExerciseSection(exercises: summary.exercises),
          ],
        ),
      );
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.summary, this.onEdit});

  final SessionSummaryModel summary;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: .12),
            foregroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.assignment_turned_in_outlined),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Session summary',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  DateFormat('d MMM yyyy · h:mm a').format(summary.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF667575),
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              key: const ValueKey<String>('edit-session-summary'),
              tooltip: 'Edit latest session summary',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      );
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(value, style: const TextStyle(height: 1.35)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ExerciseSection extends StatelessWidget {
  const _ExerciseSection({required this.exercises});

  final List<RecommendedExercise> exercises;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 7,
        runSpacing: 7,
        children: exercises
            .map((RecommendedExercise exercise) => Chip(
                  avatar: const Icon(Icons.self_improvement_rounded, size: 16),
                  label: Text(exercise.label),
                  visualDensity: VisualDensity.compact,
                ))
            .toList(),
      );
}
