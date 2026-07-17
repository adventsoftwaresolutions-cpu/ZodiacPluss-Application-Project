import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../themes/app_radius.dart';
import '../../../themes/app_spacing.dart';
import '../data/models/kundali_dosha_model.dart';
import '../data/provider/kundali_doshas_provider.dart';
import 'kundali_dosha_result_card.dart';
import 'kundali_doshas_loading.dart';
import 'kundali_doshas_overview.dart';
import 'kundali_papa_samyam_card.dart';

class KundaliDoshasBody extends ConsumerWidget {
  const KundaliDoshasBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doshas = ref.watch(kundaliDoshasProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, AppSpacing.lg),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: doshas.when(
          data: (data) => _DoshasContent(
            key: const ValueKey('kundali-doshas-data'),
            data: data,
          ),
          loading: () => const KundaliDoshasLoading(
            key: ValueKey('kundali-doshas-loading'),
          ),
          error: (error, stackTrace) => _DoshasError(
            key: const ValueKey('kundali-doshas-error'),
            onRetry: () => ref.invalidate(kundaliDoshasProvider),
          ),
        ),
      ),
    );
  }
}

class _DoshasContent extends StatelessWidget {
  const _DoshasContent({super.key, required this.data});

  final KundaliDoshasData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KundaliDoshasOverview(data: data),
        const SizedBox(height: AppSpacing.md),
        KundaliDoshaResultCard(result: data.mangal),
        const SizedBox(height: AppSpacing.md),
        KundaliDoshaResultCard(result: data.kaalSarp),
        const SizedBox(height: AppSpacing.md),
        KundaliPapaSamyamCard(result: data.papaSamyam),
        const SizedBox(height: AppSpacing.md),
        const _SupportedScopeNote(),
      ],
    );
  }
}

class _SupportedScopeNote extends StatelessWidget {
  const _SupportedScopeNote();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.primary.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: colors.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Supported checks only: Mangal Dosha, Kaal Sarp Dosha and Papa '
              'Samyam. Sade Sati is shown under Timing. Other doshas are not '
              'inferred without a validated calculation source.',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    height: 1.4,
                    color: colors.onSurface.withValues(alpha: 0.64),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoshasError extends StatelessWidget {
  const _DoshasError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield_outlined, size: 36),
            const SizedBox(height: AppSpacing.sm),
            const Text('Unable to load Dosha analysis.'),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
