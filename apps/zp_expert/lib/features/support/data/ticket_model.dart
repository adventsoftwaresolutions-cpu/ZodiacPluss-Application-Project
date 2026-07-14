import 'package:flutter/foundation.dart';

enum TicketProgress { all, inProgress, resolved, closed }

extension TicketProgressLabel on TicketProgress {
  String get label => switch (this) {
        TicketProgress.all => 'All tickets',
        TicketProgress.inProgress => 'In Progress',
        TicketProgress.resolved => 'Resolved',
        TicketProgress.closed => 'Closed',
      };
}

@immutable
class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.category,
    required this.subject,
    required this.description,
    required this.createdAt,
    this.progress = TicketProgress.inProgress,
    this.latestUpdate,
    this.attachments = const <String>[],
  });

  final String id;
  final String category;
  final String subject;
  final String description;
  final DateTime createdAt;
  final TicketProgress progress;
  final String? latestUpdate;
  final List<String> attachments;
}
