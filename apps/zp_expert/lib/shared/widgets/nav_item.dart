import 'package:flutter/material.dart';

class NavItem {
  const NavItem({
    required this.icon,
    required this.selectedIcon,
  });

  final IconData icon;
  final IconData selectedIcon;
}
