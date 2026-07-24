import 'package:flutter/material.dart';

import '../data/models/kundali_birth_data.dart';
import 'kundali_theme.dart';
import 'widgets/kundali_content.dart';
import 'widgets/kundali_layout.dart';
import 'widgets/kundali_primary_navigation.dart';

/// Shared, route-free Kundali content.
///
/// Consuming apps own the header, navigation, scaffold, and outer background.
/// Theme differences can be supplied through [KundaliThemeData].
class KundaliView extends StatelessWidget {
  const KundaliView({
    required this.birthData,
    this.maxContentWidth = 720,
    this.topBorderRadius = 28,
    super.key,
  });

  final KundaliBirthData birthData;
  final double maxContentWidth;
  final double topBorderRadius;

  @override
  Widget build(BuildContext context) {
    final kundaliTheme = KundaliThemeData.resolve(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kundaliTheme.contentBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topBorderRadius),
        ),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: const KundaliPrimaryNavigation(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Padding(
                  padding: const EdgeInsets.only(top: KundaliSpacing.sm),
                  child: KundaliContent(birthData: birthData),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
