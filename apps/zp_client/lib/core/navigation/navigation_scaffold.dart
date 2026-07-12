import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/consult/consult.dart';
import '../../features/sessions/sessions.dart';
import '../../features/wellness/wellness.dart';
import '../../features/home/home.dart';

import '../../shared/widgets/animated_navbar.dart';
import 'navigation_provider.dart';

class NavigationScaffold extends ConsumerWidget {
  const NavigationScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomePage(), 
          ConsultPage(),
          WellnessPage(),
          SessionsPage(),
        ],
      ),

      bottomNavigationBar: ZPAnimatedNavbar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(navigationProvider.notifier).state = index,
        items: const [
          ZPNavItem(iconAsset: 'assets/icons/home.svg', label: 'Home'),
          ZPNavItem(iconAsset: 'assets/icons/consult.svg', label: 'Consult'),
          ZPNavItem(iconAsset: 'assets/icons/wellness.svg', label: 'Wellness'),
          ZPNavItem(iconAsset: 'assets/icons/session.svg', label: 'Sessions'),
        ],
      ),
    );
  }
}