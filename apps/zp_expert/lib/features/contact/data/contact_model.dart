import 'package:flutter/material.dart';

enum ContactActionDestination { raiseTicket, ticketStatus, faq }

class ContactAction {
  final String title;
  final String subtitle;
  final String icon;

  const ContactAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.destination,
  });

  final ContactActionDestination? destination;
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
