import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import 'widgets/client_history_content.dart';
import 'widgets/clients_header.dart';

class ClientHistoryPage extends StatelessWidget {
  const ClientHistoryPage({required this.clientId, super.key});

  final String clientId;

  @override
  Widget build(BuildContext context) {
    return GradientPage(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            children: <Widget>[
              ClientsHeader(
                title: 'Client History',
                subtitle: 'Detail about client',
                onBackTap: () => Navigator.of(context).maybePop(),
                onNotificationTap: () {},
                onChatTap: () {},
              ),
              const SizedBox(height: 24),
              Expanded(
                child: TopScrollFade(
                  child: ClientHistoryContent(clientId: clientId),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
