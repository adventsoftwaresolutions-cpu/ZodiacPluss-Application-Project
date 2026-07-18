import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_routes.dart';
import '../../shared/widgets/gradient_page.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import '../session/widgets/session_history_header.dart';
import 'widgets/reviews_content.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) => GradientPage(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              children: <Widget>[
                SessionHistoryHeader(
                  title: 'Reviews',
                  subtitle: 'Feedback shared by your clients',
                  onBackTap: () => Navigator.of(context).maybePop(),
                  onNotificationTap: () {},
                  onChatTap: () => context.push(ExpertRoutes.chats),
                ),
                const SizedBox(height: 24),
                const Expanded(
                  child: TopScrollFade(child: ReviewsContent()),
                ),
              ],
            ),
          ),
        ),
      );
}
