import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../navigation/app_routes.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import 'data/ticket_model.dart';
import 'data/ticket_provider.dart';
import 'data/ticket_repository.dart';
import 'widgets/ticket_header.dart';
import 'widgets/ticket_quick_help.dart';
import 'widgets/ticket_status_filters.dart';
import 'widgets/ticket_update_card.dart';

class TicketStatusPage extends ConsumerWidget {
  const TicketStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TicketProgress filter = ref.watch(ticketFilterProvider);
    final AsyncValue<List<SupportTicket>> tickets =
        ref.watch(ticketListProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: <Color>[AppColors.primary, AppColors.secondary],
            stops: <double>[0, .36],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              TicketHeader(
                title: 'Ticket Status',
                subtitle: 'Track your tickets and view all updates',
                onBackTap: () => context.pop(),
                onNotificationTap: () => _showMessage(
                    context, 'Notifications are not available yet.'),
                onChatTap: () =>
                    _showMessage(context, 'Messages are not available yet.'),
              ),
              Expanded(
                child: TopScrollFade(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'My Tickets',
                          style: TextStyle(
                            color: AppColors.ticketText,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TicketStatusFilters(
                          selectedFilter: filter,
                          onSelected:
                              ref.read(ticketFilterProvider.notifier).select,
                        ),
                        const SizedBox(height: 22),
                        tickets.when(
                          data: (List<SupportTicket> ticketList) {
                            final List<SupportTicket> visibleTickets =
                                filter == TicketProgress.all
                                    ? ticketList
                                    : ticketList
                                        .where((SupportTicket ticket) =>
                                            ticket.progress == filter)
                                        .toList();
                            if (visibleTickets.isEmpty) {
                              return const _EmptyTickets();
                            }
                            return Column(
                              children: visibleTickets
                                  .map((SupportTicket ticket) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: TicketUpdateCard(ticket: ticket),
                                      ))
                                  .toList(),
                            );
                          },
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(
                                  color: AppColors.primary),
                            ),
                          ),
                          error: (Object error, StackTrace stackTrace) =>
                              const _EmptyTickets(),
                        ),
                        const SizedBox(height: 8),
                        TicketQuickHelp(
                          onFaqTap: () => context.push(ExpertRoutes.faq),
                          onContactTap: () =>
                              context.push(ExpertRoutes.contact),
                          onRaiseTicketTap: () =>
                              context.push(ExpertRoutes.raiseTicket),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
}

class _EmptyTickets extends StatelessWidget {
  const _EmptyTickets();

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: .9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          children: <Widget>[
            Icon(Icons.confirmation_number_outlined,
                color: AppColors.primary, size: 32),
            SizedBox(height: 8),
            Text('No tickets in this category yet.'),
          ],
        ),
      );
}
