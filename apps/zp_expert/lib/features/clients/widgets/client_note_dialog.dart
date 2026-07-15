import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/constants/app_assets.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';

class ClientNoteDialog extends StatefulWidget {
  const ClientNoteDialog({required this.initialNote, super.key});

  final String? initialNote;

  @override
  State<ClientNoteDialog> createState() => _ClientNoteDialogState();
}

class _ClientNoteDialogState extends State<ClientNoteDialog> {
  late final TextEditingController _controller;

  bool get _hasNote => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote)
      ..addListener(_onNoteChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onNoteChanged)
      ..dispose();
    super.dispose();
  }

  void _onNoteChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.initialNote?.trim().isNotEmpty ?? false;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 28,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 46,
                  height: 46,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: SvgPicture.asset(
                    AppAssets.notesIcon,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        isEditing ? 'Client note' : 'Add a client note',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Private to your expert account',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mutedText,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _controller,
              autofocus: true,
              minLines: 4,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Write a helpful note about this client…',
                filled: true,
                fillColor: AppColors.primary.withValues(alpha: .06),
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: .16),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _hasNote
                      ? () => Navigator.of(context).pop(_controller.text.trim())
                      : null,
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: Text(isEditing ? 'Save changes' : 'Save note'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
