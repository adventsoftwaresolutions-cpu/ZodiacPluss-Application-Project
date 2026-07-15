import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/provider/session_history_provider.dart';
import 'session_overview_card.dart';
import 'session_price_breakdown_card.dart';
import 'session_summary_card.dart';

class SessionInfoContent extends ConsumerWidget {
  const SessionInfoContent({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionDetail = ref.watch(sessionDetailProvider(sessionId));

    return sessionDetail.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const Center(
        child: Text('Unable to load session details. Please try again.'),
      ),
      data: (detail) => ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 116),
        children: <Widget>[
          SessionOverviewCard(detail: detail),
          const SizedBox(height: 16),
          const SessionReplayCard(),
          const SizedBox(height: 16),
          SessionSummaryCard(detail: detail),
          const SizedBox(height: 16),
          SessionPriceBreakdownCard(detail: detail),
        ],
      ),
    );
  }
}
