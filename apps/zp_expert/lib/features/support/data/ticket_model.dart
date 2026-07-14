import 'package:flutter/foundation.dart';

@immutable
class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.category,
    required this.subject,
    required this.description,
    required this.createdAt,
    this.attachments = const <String>[],
  });

  final String id;
  final String category;
  final String subject;
  final String description;
  final DateTime createdAt;
  final List<String> attachments;
}
