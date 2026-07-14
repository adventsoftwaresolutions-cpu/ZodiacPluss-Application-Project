import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import '../../../themes/app_spacing.dart';
import '../data/ticket.dart';
import '../data/ticket_controller.dart';
import '../data/ticket_repository.dart';
import 'widgets/ticket_widgets.dart';

class RaiseTicketPage extends ConsumerStatefulWidget {
  const RaiseTicketPage({super.key});

  @override
  ConsumerState<RaiseTicketPage> createState() => _RaiseTicketPageState();
}

class _RaiseTicketPageState extends ConsumerState<RaiseTicketPage> {
  static const List<String> _categories = <String>[
    'Payment & wallet',
    'Sessions',
    'Expert verification',
    'Technical issue',
    'Account',
    'Other',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final TicketFormState state = ref.read(ticketControllerProvider);
    if (state.category == null) {
      _showMessage('Please select a category.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final SupportTicket ticket =
        await ref.read(ticketControllerProvider.notifier).submit(
              subject: _subjectController.text.trim(),
              description: _descriptionController.text.trim(),
            );
    if (!mounted) return;
    _subjectController.clear();
    _descriptionController.clear();
    ref.read(ticketControllerProvider.notifier).reset();
    ref.invalidate(supportTicketsProvider);
    _showMessage('Ticket ${ticket.id} submitted successfully.');
  }

  Future<void> _showStatus() async {
    final List<SupportTicket> tickets =
        await ref.read(ticketRepositoryProvider).fetchTickets();
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: tickets.isEmpty
              ? const SizedBox(
                  height: 150,
                  child:
                      Center(child: Text('No tickets have been raised yet.')),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Ticket Status',
                        style: TicketStyles.sectionTitle),
                    const SizedBox(height: 12),
                    ...tickets.map(
                      (SupportTicket ticket) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.ticketField,
                          child: Icon(Icons.confirmation_number_outlined,
                              color: AppColors.primary),
                        ),
                        title: Text(ticket.subject),
                        subtitle: Text('${ticket.id} · Open'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _showMessage(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final TicketFormState formState = ref.watch(ticketControllerProvider);
    final TicketController controller =
        ref.read(ticketControllerProvider.notifier);

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
              TicketPageHeader(
                onBack: () => context.pop(),
                onNotification: () =>
                    _showMessage('Notifications are not available yet.'),
                onChat: () => _showMessage('Messages are not available yet.'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.xl,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TicketFormCard(
                          categories: _categories,
                          state: formState,
                          subjectController: _subjectController,
                          descriptionController: _descriptionController,
                          onCategorySelected: controller.selectCategory,
                          onAddAttachment: controller.addAttachment,
                          onRemoveAttachment: controller.removeAttachment,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _SubmitButton(
                          isSubmitting: formState.isSubmitting,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        TicketStatusCard(onTap: _showStatus),
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
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.isSubmitting, required this.onPressed});

  final bool isSubmitting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 44,
        width: 225,
        child: FilledButton.icon(
          onPressed: isSubmitting ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            textStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          icon: isSubmitting
              ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.send_rounded, size: 18),
          label: Text(isSubmitting ? 'Submitting...' : 'Submit Ticket'),
        ),
      );
}
