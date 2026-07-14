import 'package:flutter/material.dart';

class ContactAction {
  final String title;
  final String subtitle;
  final String icon;

  const ContactAction({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class ContactInfo {
  final String title;
  final String value;
  final IconData icon;

  const ContactInfo({
    required this.title,
    required this.value,
    required this.icon,
  });
}