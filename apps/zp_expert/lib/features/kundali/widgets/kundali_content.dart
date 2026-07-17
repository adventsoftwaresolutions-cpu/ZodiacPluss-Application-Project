import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/kundali_page_section.dart';
import '../data/provider/kundali_page_provider.dart';
import 'kundali_chart_panel.dart';
import 'kundali_doshas_body.dart';
import 'kundali_planets_body.dart';
import 'kundali_timing_body.dart';

class KundaliContent extends ConsumerWidget {
  const KundaliContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(kundaliPageSectionProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: switch (section) {
        KundaliPageSection.charts => const KundaliChartsBody(
            key: ValueKey('kundali-charts'),
          ),
        KundaliPageSection.planets => const KundaliPlanetsBody(
            key: ValueKey('kundali-planets'),
          ),
        KundaliPageSection.timing => const KundaliTimingBody(
            key: ValueKey('kundali-timing'),
          ),
        KundaliPageSection.doshas => const KundaliDoshasBody(
            key: ValueKey('kundali-doshas'),
          ),
      },
    );
  }
}
