import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../themes/app_radius.dart';
import '../data/models/kundali_planet_model.dart';

class KundaliPlanetsTable extends StatelessWidget {
  const KundaliPlanetsTable({super.key, required this.positions});

  final List<KundaliPlanetPosition> positions;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.public_rounded, color: colors.primary, size: 20),
              const SizedBox(width: 7),
              Text(
                'Planets',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Swipe horizontally for Nakshatra and house details.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.58),
                ),
          ),
          const SizedBox(height: 10),
          _PlanetTableGrid(positions: positions),
        ],
      ),
    );
  }
}

class _PlanetTableGrid extends StatefulWidget {
  const _PlanetTableGrid({required this.positions});

  final List<KundaliPlanetPosition> positions;

  @override
  State<_PlanetTableGrid> createState() => _PlanetTableGridState();
}

class _PlanetTableGridState extends State<_PlanetTableGrid> {
  static const _firstColumnWidth = 112.0;
  static const _headerHeight = 48.0;
  static const _rowHeight = 44.0;
  static const _scrollableWidth = 660.0;

  final ScrollController _scrollController = ScrollController();
  bool _showRightHint = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollHint);
  }

  void _updateScrollHint() {
    if (!_scrollController.hasClients) return;
    final show = _scrollController.position.extentAfter > 4;
    if (show != _showRightHint) setState(() => _showRightHint = show);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateScrollHint)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final borderColor = colors.primary.withValues(alpha: 0.42);
    final contentHeight =
        _headerHeight + (_rowHeight * widget.positions.length);
    final tableHeight = contentHeight + 16;

    return Container(
      height: tableHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          SizedBox(
            height: contentHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: _firstColumnWidth,
                  child: _FixedPlanetColumn(
                    positions: widget.positions,
                    headerHeight: _headerHeight,
                    rowHeight: _rowHeight,
                    borderColor: borderColor,
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          width: _scrollableWidth,
                          child: _ScrollablePlanetColumns(
                            positions: widget.positions,
                            headerHeight: _headerHeight,
                            rowHeight: _rowHeight,
                            borderColor: borderColor,
                          ),
                        ),
                      ),
                      IgnorePointer(
                        child: AnimatedOpacity(
                          opacity: _showRightHint ? 1 : 0,
                          duration: const Duration(milliseconds: 160),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 22,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colors.surface.withValues(alpha: 0),
                                    colors.surface.withValues(alpha: 0.84),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(_firstColumnWidth + 8, 4, 8, 4),
            child: _HorizontalScrollIndicator(controller: _scrollController),
          ),
        ],
      ),
    );
  }
}

class _HorizontalScrollIndicator extends StatelessWidget {
  const _HorizontalScrollIndicator({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final position = controller.hasClients ? controller.position : null;
        final hasDimensions = position?.hasContentDimensions ?? false;
        final maxExtent = hasDimensions ? position!.maxScrollExtent : 0.0;
        final offset =
            hasDimensions ? position!.pixels.clamp(0.0, maxExtent) : 0.0;

        return LayoutBuilder(
          builder: (context, constraints) {
            final fraction = maxExtent == 0
                ? 1.0
                : (position!.viewportDimension /
                        (maxExtent + position.viewportDimension))
                    .clamp(0.12, 1.0);
            final thumbWidth = constraints.maxWidth * fraction;
            final thumbLeft = maxExtent == 0
                ? 0.0
                : (constraints.maxWidth - thumbWidth) * (offset / maxExtent);

            return Container(
              height: 6,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: Offset(thumbLeft, 0),
                  child: Container(
                    width: thumbWidth,
                    height: 6,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.48),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FixedPlanetColumn extends StatelessWidget {
  const _FixedPlanetColumn({
    required this.positions,
    required this.headerHeight,
    required this.rowHeight,
    required this.borderColor,
  });

  final List<KundaliPlanetPosition> positions;
  final double headerHeight;
  final double rowHeight;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        right: BorderSide(color: borderColor),
        horizontalInside: BorderSide(color: borderColor),
      ),
      children: [
        TableRow(
          children: [
            _TableCell(
              value: 'Planet',
              height: headerHeight,
              isHeader: true,
            ),
          ],
        ),
        for (final position in positions)
          TableRow(
            children: [
              _PlanetCell(position: position, height: rowHeight),
            ],
          ),
      ],
    );
  }
}

class _ScrollablePlanetColumns extends StatelessWidget {
  const _ScrollablePlanetColumns({
    required this.positions,
    required this.headerHeight,
    required this.rowHeight,
    required this.borderColor,
  });

  final List<KundaliPlanetPosition> positions;
  final double headerHeight;
  final double rowHeight;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(110),
        1: FixedColumnWidth(105),
        2: FixedColumnWidth(100),
        3: FixedColumnWidth(150),
        4: FixedColumnWidth(120),
        5: FixedColumnWidth(75),
      },
      border: TableBorder(
        horizontalInside: BorderSide(color: borderColor),
        verticalInside: BorderSide(color: borderColor),
      ),
      children: [
        TableRow(
          children: [
            for (final heading in const [
              'Sign',
              'Sign Lord',
              'Degree',
              'Nakshatra',
              'Naksh Lord',
              'House',
            ])
              _TableCell(
                value: heading,
                height: headerHeight,
                isHeader: true,
              ),
          ],
        ),
        for (final position in positions)
          TableRow(
            children: [
              _TableCell(value: position.sign, height: rowHeight),
              _TableCell(value: position.signLord.label, height: rowHeight),
              _TableCell(value: position.degreeLabel, height: rowHeight),
              _TableCell(value: position.nakshatra, height: rowHeight),
              _TableCell(value: position.nakshatraLord, height: rowHeight),
              _TableCell(value: '${position.house}', height: rowHeight),
            ],
          ),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.value,
    required this.height,
    this.isHeader = false,
  });

  final String value;
  final double height;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      alignment: Alignment.center,
      color: isHeader ? colors.primary.withValues(alpha: 0.12) : null,
      child: Text(
        value,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: (isHeader
                ? Theme.of(context).textTheme.bodyMedium
                : Theme.of(context).textTheme.bodySmall)
            ?.copyWith(
          color: isHeader
              ? colors.primary
              : colors.onSurface.withValues(alpha: 0.66),
          fontWeight: isHeader ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
    );
  }
}

class _PlanetCell extends StatelessWidget {
  const _PlanetCell({required this.position, required this.height});

  final KundaliPlanetPosition position;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          const SizedBox(width: 7),
          if (position.asset case final asset?)
            SvgPicture.asset(asset, width: 20, height: 20)
          else
            Icon(
              Icons.north_east_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              position.planet.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.72),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
