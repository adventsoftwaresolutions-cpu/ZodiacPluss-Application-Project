import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'kundali_layout.dart';
import '../../data/models/kundali_chart_model.dart';
import 'kundali_info_card.dart';

class PlanetShortFormsCard extends StatelessWidget {
  const PlanetShortFormsCard({super.key, required this.items});

  final List<KundaliShortForm> items;

  @override
  Widget build(BuildContext context) {
    return KundaliInfoCard(
      title: 'Planet Short Forms',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth < 340 ? 2 : 4;
          final width =
              (constraints.maxWidth - (KundaliSpacing.sm * (columns - 1))) /
                  columns;

          return Wrap(
            spacing: KundaliSpacing.sm,
            runSpacing: 12,
            children: items.map((item) {
              return SizedBox(
                width: width,
                child: _PlanetLegendItem(item: item),
              );
            }).toList(growable: false),
          );
        },
      ),
    );
  }
}

class _PlanetLegendItem extends StatelessWidget {
  const _PlanetLegendItem({required this.item});

  final KundaliShortForm item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (item.asset != null)
          SvgPicture.asset(item.asset!, width: 24, height: 24)
        else
          _FallbackShortForm(shortForm: item.shortForm),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.66),
                ),
          ),
        ),
      ],
    );
  }
}

class CommonShortFormsCard extends StatelessWidget {
  const CommonShortFormsCard({super.key, required this.items});

  final List<KundaliShortForm> items;

  @override
  Widget build(BuildContext context) {
    final midpoint = (items.length / 2).ceil();

    return KundaliInfoCard(
      title: 'Other Common Short Forms',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: _ShortFormColumn(items: items.take(midpoint).toList())),
          const SizedBox(width: 12),
          Expanded(
              child: _ShortFormColumn(items: items.skip(midpoint).toList())),
        ],
      ),
    );
  }
}

class _ShortFormColumn extends StatelessWidget {
  const _ShortFormColumn({required this.items});

  final List<KundaliShortForm> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 28,
                child: Text(
                  item.shortForm,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Expanded(
                child: Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.65),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        );
      }).toList(growable: false),
    );
  }
}

class HowToReadChartCard extends StatelessWidget {
  const HowToReadChartCard({super.key, required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return KundaliInfoCard(
      title: 'How to read your chart',
      child: Column(
        children: List.generate(tips.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == tips.length - 1 ? 0 : 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      tips[index],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            height: 1.35,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.68),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _FallbackShortForm extends StatelessWidget {
  const _FallbackShortForm({required this.shortForm});

  final String shortForm;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: Text(
        shortForm,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
