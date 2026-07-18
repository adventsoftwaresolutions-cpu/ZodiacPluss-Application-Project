import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import '../session/widgets/session_history_header.dart';
import 'widgets/chat_inbox_content.dart';

class ChatInboxPage extends StatelessWidget {
  const ChatInboxPage({super.key});

  @override
  Widget build(BuildContext context) => GradientPage(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              children: <Widget>[
                SessionHistoryHeader(
                  title: 'Client Chats',
                  subtitle: 'Continue conversations with past clients',
                  onBackTap: () => Navigator.of(context).maybePop(),
                  onNotificationTap: () {},
                  onChatTap: () {},
                  showActionButtons: false,
                ),
                const SizedBox(height: 20),
                const Expanded(child: ChatInboxContent()),
              ],
            ),
          ),
        ),
      );
}
