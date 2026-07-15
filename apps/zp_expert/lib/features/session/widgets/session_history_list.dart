import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/app_routes.dart';
import '../data/models/session_history_model.dart';
import '../data/provider/session_history_provider.dart';
import 'session_history_card.dart';
import 'session_history_card_skeleton.dart';

class SessionHistoryList extends ConsumerWidget {
  const SessionHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SessionHistoryModel>> sessions =
        ref.watch(sessionHistoryProvider);

    return sessions.when(
      loading: () => const _StaggeredSessionList.loading(
        key: ValueKey<String>('session-history-loading'),
      ),
      error: (error, stackTrace) => const Center(
        child: Text('Unable to load session history. Please try again.'),
      ),
      data: (items) => _StaggeredSessionList.sessions(
        key: const ValueKey<String>('session-history-data'),
        sessions: items,
      ),
    );
  }
}

class _StaggeredSessionList extends StatefulWidget {
  const _StaggeredSessionList.loading({super.key})
      : sessions = const <SessionHistoryModel>[],
        isLoading = true;

  const _StaggeredSessionList.sessions({
    required this.sessions,
    super.key,
  }) : isLoading = false;

  final List<SessionHistoryModel> sessions;
  final bool isLoading;

  @override
  State<_StaggeredSessionList> createState() => _StaggeredSessionListState();
}

class _StaggeredSessionListState extends State<_StaggeredSessionList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 920),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int count = widget.isLoading ? 6 : widget.sessions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 32),
            itemCount: count + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'All Sessions',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                );
              }

              return _AnimatedSessionEntry(
                animation: _entryAnimation(index - 1, count),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: widget.isLoading
                      ? const SessionHistoryCardSkeleton()
                      : SessionHistoryCard(
                          session: widget.sessions[index - 1],
                          onTap: () => context.push(
                            ExpertRoutes.sessionInfoFor(
                              widget.sessions[index - 1].id,
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Animation<double> _entryAnimation(int index, int count) {
    const double segment = .34;
    final double start = count <= 1 ? 0 : index / (count - 1) * (1 - segment);
    final double end = math.min(1, start + segment);

    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }
}

class _AnimatedSessionEntry extends StatelessWidget {
  const _AnimatedSessionEntry({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, .08),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
