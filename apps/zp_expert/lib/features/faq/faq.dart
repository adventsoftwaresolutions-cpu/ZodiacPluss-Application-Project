import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_routes.dart';
import '../../shared/widgets/gradient_page.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import 'widgets/faq_header.dart';
import 'widgets/faq_list.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientPage(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            0,
          ),
          child: Column(
            children: <Widget>[
              FaqHeader(
                onBackTap: () => Navigator.pop(context),
                onNotificationTap: () {},
                onChatTap: () => context.push(ExpertRoutes.chats),
              ),
              const SizedBox(height: 28),
              const Expanded(
                child: TopScrollFade(child: FaqList()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
