import 'package:flutter/material.dart';

import '../../../themes/app_radius.dart';
import '../data/models/chat_conversation_model.dart';

class ChatConversationHeader extends StatelessWidget {
  const ChatConversationHeader({
    required this.conversation,
    required this.onBackTap,
    super.key,
  });

  final ChatConversationModel conversation;
  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          _HeaderButton(onTap: onBackTap),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white.withValues(alpha: .92),
            child: Text(
              _initials(conversation.clientName),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  conversation.clientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  conversation.consultationLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: .82),
                      ),
                ),
              ],
            ),
          ),
          if (conversation.isOnline)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .16),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(radius: 3.5, backgroundColor: Color(0xFF5DE28A)),
                  SizedBox(width: 5),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );

  String _initials(String name) => name
      .trim()
      .split(RegExp(r'\s+'))
      .take(2)
      .where((String part) => part.isNotEmpty)
      .map((String part) => part[0].toUpperCase())
      .join();
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: const SizedBox(
            width: 42,
            height: 42,
            child: Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
        ),
      );
}
