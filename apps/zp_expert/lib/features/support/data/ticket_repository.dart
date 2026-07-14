import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ticket.dart';

/// Mirrors the future Supabase ticket data source while keeping this frontend
/// implementation entirely in memory.
abstract class TicketRepository {
  Future<SupportTicket> createTicket(SupportTicket ticket);
  Future<List<SupportTicket>> fetchTickets();
}

class InMemoryTicketRepository implements TicketRepository {
  final List<SupportTicket> _tickets = <SupportTicket>[];

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
