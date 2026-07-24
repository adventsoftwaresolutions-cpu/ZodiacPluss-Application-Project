import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/app_routes.dart';
import '../../../shared/data/expert_profile.dart';
import '../../../shared/widgets/top_scroll_fade.dart';
import '../../clients/widgets/client_search_field.dart';
import 'package:zp_core/zp_core.dart';
import '../data/models/chat_thread_model.dart';
import '../data/provider/chat_provider.dart';
import 'chat_thread_card.dart';
import 'chat_thread_card_skeleton.dart';

enum _InboxFilter { all, unread }

class ChatInboxContent extends ConsumerStatefulWidget {
  const ChatInboxContent({super.key});

  @override
  ConsumerState<ChatInboxContent> createState() => _ChatInboxContentState();
}

class _ChatInboxContentState extends ConsumerState<ChatInboxContent> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  _InboxFilter _filter = _InboxFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ChatInboxModel> inbox = ref.watch(chatInboxProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      child: inbox.when(
        loading: () => const _InboxLoading(
          key: ValueKey<String>('chat-loading'),
        ),
        error: (Object error, StackTrace stackTrace) => _InboxError(
          key: const ValueKey<String>('chat-error'),
          onRetry: () => ref.invalidate(chatInboxProvider),
        ),
        data: (ChatInboxModel data) => _buildInbox(data),
      ),
    );
  }

  Widget _buildInbox(ChatInboxModel inbox) {
    final List<CallRoomModel> readyRooms =
        ref.watch(incomingCallRoomsProvider).valueOrNull ??
            const <CallRoomModel>[];
    final Set<String> readyThreadIds =
        readyRooms.map((CallRoomModel room) => room.threadId).toSet();
    final List<ChatThreadModel> visibleThreads =
        _filterThreads(inbox.threads, readyThreadIds);
    return Column(
      key: const ValueKey<String>('chat-data'),
      children: <Widget>[
        _ConsultationInboxBanner(inbox: inbox),
        const SizedBox(height: 14),
        ClientSearchField(
          controller: _searchController,
          hintText: 'Search clients or messages',
          onChanged: (String value) => setState(() => _query = value),
        ),
        const SizedBox(height: 12),
        _InboxFilters(
          selected: _filter,
          unreadCount: inbox.unreadThreads,
          onSelected: (_InboxFilter value) => setState(() => _filter = value),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: TopScrollFade(
            child: visibleThreads.isEmpty
                ? const _EmptyInbox()
                : _ChatThreadList(
                    threads: visibleThreads,
                    expertRole: inbox.expertRole,
                    readyRooms: readyRooms,
                  ),
          ),
        ),
      ],
    );
  }

  List<ChatThreadModel> _filterThreads(
    List<ChatThreadModel> threads,
    Set<String> readyThreadIds,
  ) {
    final String query = _query.trim().toLowerCase();
    final List<ChatThreadModel> filtered =
        threads.where((ChatThreadModel thread) {
      final bool matchesFilter =
          _filter == _InboxFilter.all || thread.unreadCount > 0;
      final bool matchesQuery = query.isEmpty ||
          thread.clientName.toLowerCase().contains(query) ||
          thread.lastMessage.toLowerCase().contains(query) ||
          thread.consultationLabel.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();
    filtered.sort((ChatThreadModel a, ChatThreadModel b) {
      final bool aReady = readyThreadIds.contains(a.id);
      final bool bReady = readyThreadIds.contains(b.id);
      if (aReady == bReady) return 0;
      return aReady ? -1 : 1;
    });
    return filtered;
  }
}

class _ConsultationInboxBanner extends StatelessWidget {
  const _ConsultationInboxBanner({required this.inbox});

  final ChatInboxModel inbox;

  @override
  Widget build(BuildContext context) {
    final bool psychologist = inbox.expertRole == ExpertRole.psychologist;
    final Color primary = Theme.of(context).colorScheme.primary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: primary.withValues(alpha: .13),
              foregroundColor: primary,
              child: Icon(
                psychologist
                    ? Icons.psychology_outlined
                    : Icons.auto_awesome_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    psychologist
                        ? 'Private consultation follow-ups'
                        : 'Reading and guidance follow-ups',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${inbox.threads.length} past clients · ${inbox.unreadThreads} unread',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF6B7280),
                        ),
                  ),
                ],
              ),
            ),
            if (constraints.maxWidth >= 340)
              Icon(Icons.lock_outline_rounded, size: 19, color: primary),
          ],
        ),
      ),
    );
  }
}

class _InboxFilters extends StatelessWidget {
  const _InboxFilters({
    required this.selected,
    required this.unreadCount,
    required this.onSelected,
  });

  final _InboxFilter selected;
  final int unreadCount;
  final ValueChanged<_InboxFilter> onSelected;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Widget filters = Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _FilterChip(
                label: 'All',
                selected: selected == _InboxFilter.all,
                onTap: () => onSelected(_InboxFilter.all),
              ),
              const SizedBox(width: 7),
              _FilterChip(
                label: 'Unread $unreadCount',
                selected: selected == _InboxFilter.unread,
                onTap: () => onSelected(_InboxFilter.unread),
              ),
            ],
          );
          final Widget title = Text(
            'Recent chats',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          );

          if (constraints.maxWidth < 330) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                title,
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerRight, child: filters),
              ],
            );
          }
          return Row(
            children: <Widget>[
              Expanded(child: title),
              const SizedBox(width: 8),
              filters,
            ],
          );
        },
      );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF526565),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
}

class _ChatThreadList extends StatelessWidget {
  const _ChatThreadList({
    required this.threads,
    required this.expertRole,
    required this.readyRooms,
  });

  final List<ChatThreadModel> threads;
  final ExpertRole expertRole;
  final List<CallRoomModel> readyRooms;

  @override
  Widget build(BuildContext context) => ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 30),
        itemCount: threads.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 11),
        itemBuilder: (BuildContext context, int index) {
          final ChatThreadModel thread = threads[index];
          CallRoomModel? room;
          for (final CallRoomModel item in readyRooms) {
            if (item.threadId == thread.id) {
              room = item;
              break;
            }
          }
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 280 + (index * 70)),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(begin: 0, end: 1),
            builder: (BuildContext context, double value, Widget? child) =>
                Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 14 * (1 - value)),
                child: child,
              ),
            ),
            child: ChatThreadCard(
              thread: thread,
              expertRole: expertRole,
              onTap: () => context.push(
                ExpertRoutes.chatConversationFor(thread.id),
              ),
              onClientNameTap: () => context.push(
                ExpertRoutes.clientHistoryFor(thread.clientId),
              ),
              onJoinRoom: room == null
                  ? null
                  : () => context.push(ExpertRoutes.callRoomFor(room!.id)),
              joinRoomLabel: room == null ? null : 'Join ${room.type.label}',
            ),
          );
        },
      );
}

class _InboxLoading extends StatelessWidget {
  const _InboxLoading({super.key});

  @override
  Widget build(BuildContext context) => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 11),
        itemBuilder: (BuildContext context, int index) =>
            const ChatThreadCardSkeleton(),
      );
}

class _InboxError extends StatelessWidget {
  const _InboxError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.forum_outlined, size: 46),
            const SizedBox(height: 10),
            const Text('Unable to load client chats.'),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      );
}

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const <Widget>[
          SizedBox(height: 72),
          Icon(Icons.mark_chat_unread_outlined, size: 48),
          SizedBox(height: 12),
          Center(child: Text('No matching client conversations.')),
        ],
      );
}
