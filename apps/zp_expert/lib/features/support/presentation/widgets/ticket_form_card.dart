import 'package:flutter/material.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radius.dart';
import '../../../../themes/app_spacing.dart';
import '../../data/ticket_controller.dart';
import 'ticket_attachment_area.dart';
import 'ticket_intro.dart';
import 'ticket_styles.dart';

class TicketFormCard extends StatelessWidget {
  const TicketFormCard({
    required this.categories,
    required this.state,
    required this.subjectController,
    required this.descriptionController,
    required this.onCategorySelected,
    required this.onAddAttachment,
    required this.onRemoveAttachment,
    super.key,
  });

  final List<String> categories;
  final TicketFormState state;
  final TextEditingController subjectController;
  final TextEditingController descriptionController;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onAddAttachment;
  final ValueChanged<String> onRemoveAttachment;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: .96),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TicketIntro(),
            const Text('Category', style: TicketStyles.sectionTitle),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: state.category,
              style: const TextStyle(
                color: AppColors.ticketText,
                fontSize: 13,
              ),
              decoration: ticketFieldDecoration(
                hint: 'Select a Category',
                icon: Icons.grid_view_rounded,
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary),
              items: categories
                  .map((String category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (String? value) {
                if (value != null) onCategorySelected(value);
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 7, 4, 16),
              child: Text(
                'Payment, wallet, sessions, expert verification, technical issues, account or other',
                style: TicketStyles.helperText,
              ),
            ),
            const Text('Subject', style: TicketStyles.sectionTitle),
            const SizedBox(height: 8),
            TextFormField(
              controller: subjectController,
              style: const TextStyle(fontSize: 13),
              textInputAction: TextInputAction.next,
              decoration: ticketFieldDecoration(
                hint: 'Enter a short Subject',
                icon: Icons.edit_outlined,
              ),
              validator: (String? value) =>
                  value == null || value.trim().isEmpty
                      ? 'Please enter a subject.'
                      : null,
            ),
            const SizedBox(height: 16),
            const Text('Description', style: TicketStyles.sectionTitle),
            const SizedBox(height: 8),
            TextFormField(
              controller: descriptionController,
              style: const TextStyle(fontSize: 13),
              minLines: 4,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: ticketFieldDecoration(
                hint: 'Describe your issue in details',
                icon: Icons.edit_note_rounded,
              ).copyWith(alignLabelWithHint: true),
              validator: (String? value) =>
                  value == null || value.trim().isEmpty
                      ? 'Please describe the issue.'
                      : null,
            ),
            const SizedBox(height: 16),
            const Text.rich(
              TextSpan(
                text: 'Attach Files ',
                style: TicketStyles.sectionTitle,
                children: <InlineSpan>[
                  TextSpan(
                      text: '(optional)', style: TicketStyles.optionalText),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TicketAttachmentArea(
              attachments: state.attachments,
              onAddAttachment: onAddAttachment,
              onRemoveAttachment: onRemoveAttachment,
            ),
          ],
        ),
      );
}

InputDecoration ticketFieldDecoration({
  required String hint,
  required IconData icon,
}) =>
    InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.mutedText, fontSize: 13),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 21),
      filled: true,
      fillColor: AppColors.ticketField,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
