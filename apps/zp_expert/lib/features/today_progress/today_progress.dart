import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_routes.dart';
import '../../shared/widgets/glass_top_bar.dart';
import '../../shared/widgets/gradient_page.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import 'data/models/today_progress_model.dart';
import 'data/provider/today_progress_provider.dart';
import 'widgets/overview_card.dart';
import 'widgets/session_status_card.dart';
import 'widgets/consultation_card.dart';
import 'widgets/time_availability_card.dart';
import 'widgets/client_engagement_card.dart';

class TodayProgressPage extends ConsumerWidget {
  const TodayProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<TodayProgressData> progressAsync =
        ref.watch(todayProgressProvider);

    return GradientPage(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: GlassTopBar.rootPagePadding,
              child: GlassTopBar(
                title: "Today's Stats",
                onBackTap: () => context.pop(),
                onNotificationTap: () {},
                onChatTap: () => context.push(ExpertRoutes.chats),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: progressAsync.when(
                data: (TodayProgressData data) => _ProgressBody(data: data),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                error: (Object error, StackTrace stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Unable to load progress data',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBody extends StatelessWidget {
  const _ProgressBody({required this.data});

  final TodayProgressData data;

  @override
  Widget build(BuildContext context) {
    return TopScrollFade(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          MediaQuery.of(context).viewPadding.bottom + 24,
        ),
        child: Column(
          children: <Widget>[
            OverviewCard(data: data.overview),
            const SizedBox(height: 12),
            SessionStatusCard(data: data.sessionStatus),
            const SizedBox(height: 12),
            ConsultationCard(data: data.consultation),
            const SizedBox(height: 12),
            TimeAvailabilityCard(data: data.timeAvailability),
            const SizedBox(height: 12),
            ClientEngagementCard(data: data.clientEngagement),
            const SizedBox(height: 44),
          ],
        ),
      ),
    );
  }
}
