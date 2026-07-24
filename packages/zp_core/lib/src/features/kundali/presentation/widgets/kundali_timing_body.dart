import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/kundali_birth_data.dart';
import '../../data/models/kundali_timing_model.dart';
import '../../data/provider/kundali_timing_provider.dart';
import 'kundali_current_dasha_card.dart';
import 'kundali_dasha_timeline.dart';
import 'kundali_layout.dart';
import 'kundali_sade_sati_card.dart';
import 'kundali_timing_loading.dart';

class KundaliTimingBody extends ConsumerWidget {
  const KundaliTimingBody({required this.birthData, super.key});

  final KundaliBirthData birthData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = KundaliTimingQuery(birthData: birthData);
    final timing = ref.watch(kundaliTimingProvider(query));
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, KundaliSpacing.lg),
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
            onRetry: () => ref.invalidate(kundaliTimingProvider(query)),
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
        const SizedBox(height: KundaliSpacing.md),
        KundaliDashaTimeline(timing: timing),
        const SizedBox(height: KundaliSpacing.md),
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
            const SizedBox(height: KundaliSpacing.sm),
            const Text('Unable to load Kundali timing.'),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
