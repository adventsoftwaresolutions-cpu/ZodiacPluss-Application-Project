import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../navigation/app_routes.dart';
import '../../shared/widgets/glass_top_bar.dart';
import '../../shared/widgets/gradient_page.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import 'data/models/overall_performance_model.dart';
import 'data/provider/overall_performance_provider.dart';
import 'widgets/performance_metrics_card.dart';
import 'widgets/period_selector.dart';

class OverallPerformancePage extends ConsumerStatefulWidget {
  const OverallPerformancePage({super.key});

  @override
  ConsumerState<OverallPerformancePage> createState() =>
      _OverallPerformancePageState();
}

class _OverallPerformancePageState
    extends ConsumerState<OverallPerformancePage> {
  PeriodMode _mode = PeriodMode.daily;
  String? _selectedPeriodKey;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<PerformanceMetrics> lifetimeAsync =
        ref.watch(lifetimePerformanceProvider);

    return GradientPage(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: GlassTopBar.rootPagePadding,
              child: GlassTopBar(
                title: 'Overall Performance',
                onBackTap: () => context.pop(),
                onNotificationTap: () {},
                onChatTap: () => context.push(ExpertRoutes.chats),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TopScrollFade(
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
                      PeriodSelector(
                        mode: _mode,
                        selectedPeriodKey: _selectedPeriodKey,
                        onModeChanged: (PeriodMode mode) {
                          setState(() {
                            _mode = mode;
                            _selectedPeriodKey = null;
                          });
                        },
                        onPeriodSelected: (String? key) {
                          setState(() => _selectedPeriodKey = key);
                        },
                      ),
                      const SizedBox(height: 12),
                      lifetimeAsync.when(
                        data: (PerformanceMetrics data) =>
                            PerformanceMetricsCard(
                          title: 'Lifetime Performance',
                          metrics: data,
                        ),
                        loading: () => const _LoadingIndicator(),
                        error: (Object e, StackTrace s) =>
                            const _ErrorMessage(),
                      ),
                      if (_selectedPeriodKey != null) ...<Widget>[
                        const SizedBox(height: 12),
                        _CustomPeriodSection(
                          periodKey: _selectedPeriodKey!,
                          mode: _mode,
                        ),
                      ],
                      const SizedBox(height: 44),
                    ],
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

class _CustomPeriodSection extends ConsumerWidget {
  const _CustomPeriodSection({
    required this.periodKey,
    required this.mode,
  });

  final String periodKey;
  final PeriodMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PerformanceMetrics> periodAsync =
        ref.watch(periodPerformanceProvider(periodKey));

    return periodAsync.when(
      data: (PerformanceMetrics data) => PerformanceMetricsCard(
        title: _formatPeriodTitle(periodKey, mode),
        metrics: data,
      ),
      loading: () => const _LoadingIndicator(),
      error: (Object e, StackTrace s) => const _ErrorMessage(),
    );
  }

  String _formatPeriodTitle(String key, PeriodMode mode) {
    if (mode == PeriodMode.daily) {
      final DateTime date = DateTime.parse(key);
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      if (date == today) return "Today's Performance";
      return DateFormat('MMM d, yyyy').format(date);
    }

    final List<String> parts = key.split('-');
    final DateTime month =
        DateTime(int.parse(parts[0]), int.parse(parts[1]));
    final DateTime now = DateTime.now();
    if (month.year == now.year && month.month == now.month) {
      return 'This Month';
    }
    return DateFormat('MMMM yyyy').format(month);
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text(
        'Unable to load performance data',
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 14,
        ),
      ),
    );
  }
}
