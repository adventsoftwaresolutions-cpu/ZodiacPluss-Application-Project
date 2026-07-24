import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/kundali_birth_data.dart';
import '../../data/provider/kundali_planets_provider.dart';
import 'kundali_layout.dart';
import 'kundali_planet_strengths.dart';
import 'kundali_planets_loading.dart';
import 'kundali_planets_table.dart';

class KundaliPlanetsBody extends ConsumerWidget {
  const KundaliPlanetsBody({required this.birthData, super.key});

  final KundaliBirthData birthData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planets = ref.watch(kundaliPlanetsProvider(birthData));

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, KundaliSpacing.lg),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: planets.when(
          data: (data) => Column(
            key: const ValueKey('kundali-planets-data'),
            children: [
              KundaliPlanetsTable(positions: data.positions),
              const SizedBox(height: 12),
              KundaliPlanetStrengths(strengths: data.strongestPlanets),
            ],
          ),
          loading: () => const KundaliPlanetsLoading(
            key: ValueKey('kundali-planets-loading'),
          ),
          error: (error, stackTrace) => _PlanetsError(
            key: const ValueKey('kundali-planets-error'),
            onRetry: () => ref.invalidate(kundaliPlanetsProvider(birthData)),
          ),
        ),
      ),
    );
  }
}

class _PlanetsError extends StatelessWidget {
  const _PlanetsError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.public_off_outlined, size: 36),
            const SizedBox(height: KundaliSpacing.sm),
            const Text('Unable to load planetary positions.'),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
