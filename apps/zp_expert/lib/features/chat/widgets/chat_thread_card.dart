import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/data/expert_profile.dart';
import '../../../themes/app_radius.dart';
import '../data/models/chat_thread_model.dart';

class ChatThreadCard extends StatelessWidget {
  const ChatThreadCard({
    required this.thread,
    required this.expertRole,
    this.onTap,
    this.onClientNameTap,
    this.onJoinRoom,
    this.joinRoomLabel,
    super.key,
  });

  final ChatThreadModel thread;
  final ExpertRole expertRole;
  final VoidCallback? onTap;
  final VoidCallback? onClientNameTap;
  final VoidCallback? onJoinRoom;
  final String? joinRoomLabel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: .12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _ClientAvatar(
                    name: thread.clientName,
                    isOnline: thread.isOnline,
                    expertRole: expertRole,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ThreadDetails(
                      thread: thread,
                      onClientNameTap: onClientNameTap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ThreadMeta(thread: thread),
                ],
              ),
              if (onJoinRoom != null) ...<Widget>[
                const SizedBox(height: 11),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    key: ValueKey<String>('thread-join-room-${thread.id}'),
                    onPressed: onJoinRoom,
                    icon: const Icon(Icons.login_rounded, size: 18),
                    label: Text(joinRoomLabel ?? 'Join paid room'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ClientAvatar extends StatelessWidget {
  const _ClientAvatar({
    required this.name,
    required this.isOnline,
    required this.expertRole,
  });

  final String name;
  final bool isOnline;
  final ExpertRole expertRole;

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CircleAvatar(
            radius: 27,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: .14),
            child: Text(
              _initials(name),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            left: -2,
            bottom: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                expertRole == ExpertRole.psychologist
                    ? Icons.psychology_outlined
                    : Icons.auto_awesome_outlined,
                size: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          if (isOnline)
            Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF35A853),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      );
}

class _ThreadDetails extends StatelessWidget {
  const _ThreadDetails({required this.thread, this.onClientNameTap});

  final ChatThreadModel thread;
  final VoidCallback? onClientNameTap;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Semantics(
            button: onClientNameTap != null,
            label: 'Open ${thread.clientName} client history',
            child: GestureDetector(
              onTap: onClientNameTap,
              child: Text(
                thread.clientName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: onClientNameTap == null
                          ? null
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: thread.unreadCount > 0
                          ? FontWeight.w800
                          : FontWeight.w700,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${thread.lastMessageSentByExpert ? 'You: ' : ''}${thread.lastMessage}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(
                        alpha: thread.unreadCount > 0 ? .78 : .55,
                      ),
                  fontWeight: thread.unreadCount > 0
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              thread.consultationLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
}

class _ThreadMeta extends StatelessWidget {
  const _ThreadMeta({required this.thread});

  final ChatThreadModel thread;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            _timeLabel(thread.lastMessageAt),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: thread.unreadCount > 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: .48),
                  fontWeight: thread.unreadCount > 0
                      ? FontWeight.w700
                      : FontWeight.w500,
                  fontSize: 10,
                ),
          ),
          const SizedBox(height: 10),
          AnimatedScale(
            duration: const Duration(milliseconds: 180),
            scale: thread.unreadCount > 0 ? 1 : 0,
            child: Container(
              constraints: const BoxConstraints(minWidth: 21, minHeight: 21),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${thread.unreadCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      );
}

String _initials(String name) {
  final List<String> words = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((String word) => word.isNotEmpty)
      .toList();
  return words.take(2).map((String word) => word[0].toUpperCase()).join();
}

String _timeLabel(DateTime date) {
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime messageDay = DateTime(date.year, date.month, date.day);
  final int difference = today.difference(messageDay).inDays;
  if (difference == 0) return DateFormat('h:mm a').format(date);
  if (difference == 1) return 'Yesterday';
  if (difference < 7) return DateFormat('EEE').format(date);
  return DateFormat('d MMM').format(date);
}
