import 'package:flutter/material.dart';

import '../../../../shared/data/expert_profile.dart';
import '../../../themes/app_radius.dart';
import '../data/models/chat_conversation_model.dart';

class ChatConversationBanner extends StatelessWidget {
  const ChatConversationBanner({
    required this.conversation,
    required this.onFillSummary,
    required this.onViewKundali,
    super.key,
  });

  final ChatConversationModel conversation;
  final VoidCallback onFillSummary;
  final VoidCallback onViewKundali;

  @override
  Widget build(BuildContext context) {
    final bool needsSummary = conversation.needsSessionSummary;

    final ({
      String widgetKey,
      IconData icon,
      String title,
      String subtitle,
      VoidCallback? onTap,
    }) content = switch (conversation.expertRole) {
      ExpertRole.psychologist => (
          widgetKey: 'session-summary-banner',
          icon: needsSummary
              ? Icons.assignment_add
              : Icons.assignment_turned_in_outlined,
          title:
              needsSummary ? 'Fill session summary' : 'Session summary added',
          subtitle: needsSummary
              ? 'Video session ended · add the client follow-up'
              : 'Review the completed session notes below',
          onTap: needsSummary ? onFillSummary : null,
        ),
      ExpertRole.astrologer => (
          widgetKey: 'view-kundali-banner',
          icon: Icons.auto_awesome_outlined,
          title: 'View Kundali',
          subtitle: 'View client Kundali and details',
          onTap: onViewKundali,
        ),
    };

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutBack,
      tween: Tween<double>(begin: .94, end: 1),
      builder: (BuildContext context, double scale, Widget? child) =>
          Transform.scale(scale: scale, child: child),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        elevation: 5,
        shadowColor: Colors.black.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          key: ValueKey<String>(content.widgetKey),
          onTap: content.onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 19,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: .12),
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(content.icon, size: 21),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        content.title,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        content.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF637272),
                            ),
                      ),
                    ],
                  ),
                ),
                if (content.onTap != null)
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
