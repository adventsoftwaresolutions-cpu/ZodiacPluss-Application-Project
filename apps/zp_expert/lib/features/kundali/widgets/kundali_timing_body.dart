import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../themes/app_spacing.dart';
import '../data/models/kundali_timing_model.dart';
import '../data/provider/kundali_timing_provider.dart';
import 'kundali_current_dasha_card.dart';
import 'kundali_dasha_timeline.dart';
import 'kundali_sade_sati_card.dart';
import 'kundali_timing_loading.dart';

class KundaliTimingBody extends ConsumerWidget {
  const KundaliTimingBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timing = ref.watch(kundaliTimingProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, AppSpacing.lg),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: timing.when(
          data: (data) => _TimingContent(
            key: const ValueKey('kundali-timing-data'),
            timing: data,
          ),
          loading: () => const KundaliTimingLoading(
            key: ValueKey('kundali-timing-loading'),
          ),
          error: (error, stackTrace) => _TimingError(
            key: const ValueKey('kundali-timing-error'),
            onRetry: () => ref.invalidate(kundaliTimingProvider),
          ),
        ),
      ),
    );
  }
}

class _TimingContent extends StatelessWidget {
  const _TimingContent({super.key, required this.timing});

  final KundaliTimingData timing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KundaliCurrentDashaCard(timing: timing),
        const SizedBox(height: AppSpacing.md),
        KundaliDashaTimeline(timing: timing),
        const SizedBox(height: AppSpacing.md),
        KundaliSadeSatiCard(status: timing.sadeSati),
      ],
    );
  }
}

class _TimingError extends StatelessWidget {
  const _TimingError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.schedule_outlined, size: 36),
            const SizedBox(height: AppSpacing.sm),
            const Text('Unable to load Kundali timing.'),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
