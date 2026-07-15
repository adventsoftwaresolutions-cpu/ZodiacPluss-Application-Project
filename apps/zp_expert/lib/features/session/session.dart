import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import 'widgets/session_history_header.dart';
import 'widgets/session_history_list.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientPage(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            children: <Widget>[
              SessionHistoryHeader(
                onBackTap: () => Navigator.of(context).maybePop(),
                onNotificationTap: () {},
                onChatTap: () {},
                showBackButton: false,
                showSubtitle: false,
              ),
              const SizedBox(height: 28),
              const Expanded(child: SessionHistoryList()),
            ],
          ),
        ),
      ),
    );
  }
}
