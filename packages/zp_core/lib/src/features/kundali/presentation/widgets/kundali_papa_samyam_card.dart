import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../shared/constants/kundali_assets.dart';
import 'kundali_layout.dart';
import '../../data/models/kundali_dosha_model.dart';
import '../../data/models/kundali_planet_model.dart';
import 'kundali_info_card.dart';

class KundaliPapaSamyamCard extends StatelessWidget {
  const KundaliPapaSamyamCard({super.key, required this.result});

  final KundaliPapaSamyamResult result;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return KundaliInfoCard(
      title: 'Papa Samyam',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _PointsBadge(points: result.totalPoints),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculated total',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${result.detectedPlacementCount} contributing placements',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.56),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: KundaliSpacing.md),
          _ReferenceDetails(references: result.references),
          const SizedBox(height: 9),
          Text(
            'The score is shown without inventing a universal severity range.',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.52),
                ),
          ),
        ],
      ),
    );
  }
}

class _PointsBadge extends StatelessWidget {
  const _PointsBadge({required this.points});

  final double points;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 58,
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.10),
        shape: BoxShape.circle,
        border: Border.all(color: colors.primary.withValues(alpha: 0.24)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            points.toStringAsFixed(2),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
          ),
          Text(
            'points',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.primary,
                  fontSize: 9,
                  height: 1,
                ),
          ),
        ],
      ),
    );
  }
}

class _ReferenceDetails extends StatelessWidget {
  const _ReferenceDetails({required this.references});

  final List<KundaliPapaReference> references;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(KundaliRadius.md),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 10),
        childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          'Placement details',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        children: references
            .map((reference) => _ReferenceRow(reference: reference))
            .toList(growable: false),
      ),
    );
  }
}

class _ReferenceRow extends StatelessWidget {
  const _ReferenceRow({required this.reference});

  final KundaliPapaReference reference;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final detected = reference.detectedPlanets;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 86,
            child: _ReferenceTitle(name: reference.name),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ReferenceDetailsContent(
              detected: detected,
              colors: colors,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferenceTitle extends StatelessWidget {
  const _ReferenceTitle({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
    );
  }
}

class _ReferenceDetailsContent extends StatelessWidget {
  const _ReferenceDetailsContent(
      {required this.detected, required this.colors});

  final List<KundaliPapaPlanetResult> detected;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    if (detected.isEmpty) {
      return Text(
        'No contributing placement',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.52),
            ),
      );
    }
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: detected
          .map((planet) => _PlanetChip(result: planet))
          .toList(growable: false),
    );
  }
}

class _PlanetChip extends StatelessWidget {
  const _PlanetChip({required this.result});

  final KundaliPapaPlanetResult result;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(KundaliRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(_assetFor(result.planet), width: 17, height: 17),
          const SizedBox(width: 5),
          Text(
            '${result.planet.label} · H${result.position}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

String _assetFor(KundaliPlanetId planet) => switch (planet) {
      KundaliPlanetId.sun => KundaliAssets.sun,
      KundaliPlanetId.moon => KundaliAssets.moon,
      KundaliPlanetId.mercury => KundaliAssets.mercury,
      KundaliPlanetId.venus => KundaliAssets.venus,
      KundaliPlanetId.mars => KundaliAssets.mars,
      KundaliPlanetId.jupiter => KundaliAssets.jupiter,
      KundaliPlanetId.saturn => KundaliAssets.saturn,
      KundaliPlanetId.rahu => KundaliAssets.rahu,
      KundaliPlanetId.ketu => KundaliAssets.ketu,
      KundaliPlanetId.uranus => KundaliAssets.uranus,
      KundaliPlanetId.neptune => KundaliAssets.neptune,
      KundaliPlanetId.pluto => KundaliAssets.pluto,
      KundaliPlanetId.ascendant => KundaliAssets.jupiter,
    };
