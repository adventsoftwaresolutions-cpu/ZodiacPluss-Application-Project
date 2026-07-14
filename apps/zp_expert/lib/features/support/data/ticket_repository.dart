import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ticket_model.dart';

/// Mirrors the future Supabase data source while ticket data remains local.
abstract class TicketRepository {
  Future<SupportTicket> createTicket(SupportTicket ticket);
  Future<List<SupportTicket>> fetchTickets();
}

class InMemoryTicketRepository implements TicketRepository {
  final List<SupportTicket> _tickets = <SupportTicket>[
    SupportTicket(
      id: 'TKT-2026-01212',
      category: 'Sessions',
      subject: 'Session Booking Issue',
      description:
          'Our team is looking into your booking issue. We’ll update you soon.',
      latestUpdate:
          'Our team is looking into your booking issue. We’ll update you soon.',
      createdAt: DateTime(2026, 7, 2, 10, 45),
    ),
    SupportTicket(
      id: 'TKT-2026-01211',
      category: 'Payment & wallet',
      subject: 'Payment not received',
      description:
          'Your payment has been successfully refunded. The amount will reflect in your account within 3–5 business days.',
      latestUpdate:
          'Your payment has been successfully refunded. The amount will reflect in your account within 3–5 business days.',
      progress: TicketProgress.resolved,
      createdAt: DateTime(2026, 7, 2, 10, 45),
    ),
    SupportTicket(
      id: 'TKT-2026-01210',
      category: 'Sessions',
      subject: 'Fake booking report',
      description:
          'After review, the booking has been identified as invalid and the case has been resolved.',
      latestUpdate:
          'After review, the booking has been identified as invalid and the case has been resolved.',
      progress: TicketProgress.closed,
      createdAt: DateTime(2026, 7, 2, 10, 45),
    ),
  ];

  @override
  Future<SupportTicket> createTicket(SupportTicket ticket) async {
    _tickets.insert(0, ticket);
    return ticket;
  }

  @override
  Future<List<SupportTicket>> fetchTickets() async =>
      List<SupportTicket>.unmodifiable(_tickets);
}

final Provider<TicketRepository> ticketRepositoryProvider =
    Provider<TicketRepository>((Ref ref) => InMemoryTicketRepository());

final FutureProvider<List<SupportTicket>> ticketListProvider =
    FutureProvider<List<SupportTicket>>(
  (Ref ref) => ref.watch(ticketRepositoryProvider).fetchTickets(),
);
