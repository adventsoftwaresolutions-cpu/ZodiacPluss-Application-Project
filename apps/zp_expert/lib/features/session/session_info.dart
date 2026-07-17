import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_routes.dart';
import '../../shared/widgets/gradient_page.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import 'data/provider/session_history_provider.dart';
import 'widgets/session_action_bar.dart';
import 'widgets/session_history_header.dart';
import 'widgets/session_info_content.dart';

class SessionInfoScreen extends ConsumerWidget {
  const SessionInfoScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isBlocked = ref
            .watch(blockedClientsProvider)
            .valueOrNull
            ?.contains('client-$sessionId') ??
        false;

    return GradientPage(
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                children: <Widget>[
                  SessionHistoryHeader(
                    title: 'Session Info',
                    subtitle: 'Detail report of session',
                    onBackTap: () => Navigator.of(context).maybePop(),
                    onNotificationTap: () {},
                    onChatTap: () => context.push(ExpertRoutes.chats),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: TopScrollFade(
                      child: SessionInfoContent(sessionId: sessionId),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: SessionActionBar(
                  isBlocked: isBlocked,
                  onBlockTap: () => _confirmBlock(context, ref),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmBlock(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block this user?'),
        content: const Text(
          'They will no longer be able to start new sessions with you.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Block user'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(blockedClientsProvider.notifier).block('client-$sessionId');
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User blocked for future sessions.')),
    );
  }
}
