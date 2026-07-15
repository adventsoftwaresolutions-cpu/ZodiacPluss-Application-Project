import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import '../data/models/client_history_model.dart';
import '../data/provider/clients_provider.dart';
import 'client_history_overview.dart';
import 'client_history_skeleton.dart';
import 'client_note_dialog.dart';
import 'client_session_card.dart';

class ClientHistoryContent extends ConsumerStatefulWidget {
  const ClientHistoryContent({required this.clientId, super.key});

  final String clientId;

  @override
  ConsumerState<ClientHistoryContent> createState() =>
      _ClientHistoryContentState();
}

class _ClientHistoryContentState extends ConsumerState<ClientHistoryContent>
    with SingleTickerProviderStateMixin {
  bool _isPastExpanded = false;
  bool _isFutureExpanded = false;
  late final AnimationController _entryController;
  bool _hasStartedEntrance = false;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(clientHistoryProvider(widget.clientId));
    final String? note =
        ref.watch(clientNotesProvider).valueOrNull?[widget.clientId];
    final Set<String> cancelledSessions =
        ref.watch(cancelledClientSessionsProvider).valueOrNull ?? <String>{};

    return history.when(
      loading: () => const ClientHistorySkeleton(),
      error: (error, stackTrace) => const Center(
        child: Text('Unable to load client history. Please try again.'),
      ),
      data: (clientHistory) {
        _startEntrance();
        final List<ClientSessionModel> upcomingSessions = clientHistory
            .upcomingSessions
            .where((session) => !cancelledSessions.contains(session.id))
            .toList(growable: false);
        final int totalEntries =
            1 + clientHistory.pastSessions.length + upcomingSessions.length;

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32),
          children: <Widget>[
            _AnimatedClientEntry(
              animation: _entryAnimation(0, totalEntries),
              child: ClientHistoryOverview(
                history: clientHistory,
                note: note,
                onNoteTap: () => _editNote(note),
              ),
            ),
            const SizedBox(height: 22),
            _HistorySection(
              title: 'Past Sessions',
              emptyMessage: 'No previous sessions with this client.',
              sessions: clientHistory.pastSessions,
              isExpanded: _isPastExpanded,
              onViewAllTap: () => _toggleSection(isPast: true),
              firstCardIndex: 1,
              entryAnimation: (index) => _entryAnimation(index, totalEntries),
            ),
            const SizedBox(height: 22),
            _HistorySection(
              title: 'Future Sessions',
              emptyMessage: 'No upcoming sessions booked.',
              sessions: upcomingSessions,
              isExpanded: _isFutureExpanded,
              onViewAllTap: () => _toggleSection(isPast: false),
              onCancel: _confirmCancellation,
              firstCardIndex: 1 + clientHistory.pastSessions.length,
              entryAnimation: (index) => _entryAnimation(index, totalEntries),
            ),
          ],
        );
      },
    );
  }

  void _startEntrance() {
    if (_hasStartedEntrance) return;
    _hasStartedEntrance = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entryController.forward();
    });
  }

  void _toggleSection({required bool isPast}) {
    setState(() {
      if (isPast) {
        _isPastExpanded = !_isPastExpanded;
      } else {
        _isFutureExpanded = !_isFutureExpanded;
      }
    });
    _entryController.forward(from: 0);
  }

  Animation<double> _entryAnimation(int index, int count) {
    const double segment = .34;
    final double start = count <= 1 ? 0 : index / (count - 1) * (1 - segment);
    final double end = math.min(1, start + segment);

    return CurvedAnimation(
      parent: _entryController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  Future<void> _editNote(String? note) async {
    final String? savedNote = await showDialog<String>(
      context: context,
      builder: (dialogContext) => ClientNoteDialog(initialNote: note),
    );

    if (savedNote == null || savedNote.isEmpty) return;
    await ref
        .read(clientNotesProvider.notifier)
        .save(widget.clientId, savedNote);
  }

  Future<void> _confirmCancellation(ClientSessionModel session) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel this meeting?'),
        content: Text(
            'The ${session.title.toLowerCase()} booking will be cancelled.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep booking'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cancel meeting'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(cancelledClientSessionsProvider.notifier)
          .cancel(session.id);
    }
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({
    required this.title,
    required this.emptyMessage,
    required this.sessions,
    required this.isExpanded,
    required this.onViewAllTap,
    required this.firstCardIndex,
    required this.entryAnimation,
    this.onCancel,
  });

  final String title;
  final String emptyMessage;
  final List<ClientSessionModel> sessions;
  final bool isExpanded;
  final VoidCallback onViewAllTap;
  final int firstCardIndex;
  final Animation<double> Function(int index) entryAnimation;
  final ValueChanged<ClientSessionModel>? onCancel;

  @override
  Widget build(BuildContext context) {
    const int previewCount = 3;
    final bool canExpand = sessions.length > previewCount;
    final List<ClientSessionModel> visibleSessions = isExpanded
        ? sessions
        : sessions.take(previewCount).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: .78),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: .06),
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            child: Column(
              children: <Widget>[
                if (visibleSessions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text(emptyMessage)),
                  )
                else
                  ...visibleSessions.asMap().entries.map(
                        (entry) => _AnimatedClientEntry(
                          animation: entryAnimation(firstCardIndex + entry.key),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: ClientSessionCard(
                              session: entry.value,
                              onCancel:
                                  entry.value.isUpcoming && onCancel != null
                                      ? () => onCancel!(entry.value)
                                      : null,
                            ),
                          ),
                        ),
                      ),
                if (canExpand)
                  TextButton.icon(
                    onPressed: onViewAllTap,
                    iconAlignment: IconAlignment.end,
                    icon: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                    ),
                    label: Text(isExpanded ? 'Show less' : 'View all sessions'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedClientEntry extends StatelessWidget {
  const _AnimatedClientEntry({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, .06),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
