import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ticket.dart';
import 'ticket_repository.dart';

@immutable
class TicketFormState {
  const TicketFormState({
    this.category,
    this.attachments = const <String>[],
    this.isSubmitting = false,
    this.submittedTicket,
  });

  final String? category;
  final List<String> attachments;
  final bool isSubmitting;
  final SupportTicket? submittedTicket;

  TicketFormState copyWith({
    String? category,
    bool clearCategory = false,
    List<String>? attachments,
    bool? isSubmitting,
    SupportTicket? submittedTicket,
    bool clearSubmittedTicket = false,
  }) =>
      TicketFormState(
        category: clearCategory ? null : (category ?? this.category),
        attachments: attachments ?? this.attachments,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        submittedTicket: clearSubmittedTicket
            ? null
            : (submittedTicket ?? this.submittedTicket),
      );
}

class TicketController extends StateNotifier<TicketFormState> {
  TicketController(this._repository) : super(const TicketFormState());

  final TicketRepository _repository;

  void selectCategory(String category) =>
      state = state.copyWith(category: category);

  void addAttachment(String fileName) {
    if (!state.attachments.contains(fileName)) {
      state =
          state.copyWith(attachments: <String>[...state.attachments, fileName]);
    }
  }

  void removeAttachment(String fileName) => state = state.copyWith(
        attachments:
            state.attachments.where((String file) => file != fileName).toList(),
      );

  Future<SupportTicket> submit({
    required String subject,
    required String description,
  }) async {
    state = state.copyWith(isSubmitting: true, clearSubmittedTicket: true);
    final SupportTicket ticket = SupportTicket(
      id: 'ZPE-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      category: state.category!,
      subject: subject,
      description: description,
      attachments: state.attachments,
      createdAt: DateTime.now(),
    );
    final SupportTicket savedTicket = await _repository.createTicket(ticket);
    state = state.copyWith(isSubmitting: false, submittedTicket: savedTicket);
    return savedTicket;
  }

  void reset() => state = const TicketFormState();
}

final StateNotifierProvider<TicketController, TicketFormState>
    ticketControllerProvider =
    StateNotifierProvider<TicketController, TicketFormState>(
  (Ref ref) => TicketController(ref.watch(ticketRepositoryProvider)),
);

final FutureProvider<List<SupportTicket>> supportTicketsProvider =
    FutureProvider<List<SupportTicket>>(
  (Ref ref) => ref.watch(ticketRepositoryProvider).fetchTickets(),
);
