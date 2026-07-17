import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import '../../themes/app_spacing.dart';
import 'widgets/kundali_chart_panel.dart';
import 'widgets/kundali_header.dart';
import 'widgets/kundali_primary_navigation.dart';

class KundaliPage extends StatelessWidget {
  const KundaliPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientPage(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: KundaliHeader(),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 720),
                          child: const KundaliPrimaryNavigation(),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 720),
                          child: const Padding(
                            padding: EdgeInsets.only(top: AppSpacing.sm),
                            child: KundaliChartsBody(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
