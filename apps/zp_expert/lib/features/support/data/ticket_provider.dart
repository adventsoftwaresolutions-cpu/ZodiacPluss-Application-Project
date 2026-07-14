import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ticket_model.dart';
import 'ticket_repository.dart';

@immutable
class TicketFormState {
  const TicketFormState({
    this.category,
    this.attachments = const <String>[],
    this.isSubmitting = false,
  });

  final String? category;
  final List<String> attachments;
  final bool isSubmitting;

  TicketFormState copyWith({
    String? category,
    List<String>? attachments,
    bool? isSubmitting,
  }) =>
      TicketFormState(
        category: category ?? this.category,
        attachments: attachments ?? this.attachments,
        isSubmitting: isSubmitting ?? this.isSubmitting,
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
    state = state.copyWith(isSubmitting: true);
    final SupportTicket ticket = SupportTicket(
      id: 'ZPE-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      category: state.category!,
      subject: subject,
      description: description,
      attachments: state.attachments,
      createdAt: DateTime.now(),
    );
    final SupportTicket savedTicket = await _repository.createTicket(ticket);
    state = const TicketFormState();
    return savedTicket;
  }
}

final StateNotifierProvider<TicketController, TicketFormState>
    ticketControllerProvider =
    StateNotifierProvider<TicketController, TicketFormState>(
  (Ref ref) => TicketController(ref.watch(ticketRepositoryProvider)),
);
