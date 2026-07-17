import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/animated_navbar.dart';
import '../../shared/widgets/nav_item.dart';
import '../../features/call_room/widgets/persistent_incoming_call_prompt.dart';

class NavigationScaffold extends StatelessWidget {
  const NavigationScaffold({
    required this.navigationShell,
    required this.items,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<NavItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const PersistentIncomingCallPrompt(),
          AnimatedNavbar(
            items: items,
            currentIndex: navigationShell.currentIndex,
            onTap: (int index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
          ),
        ],
      ),
    );
  }
}
