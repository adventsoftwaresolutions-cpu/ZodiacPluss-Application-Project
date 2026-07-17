import 'package:flutter/material.dart';

import '../../../themes/app_radius.dart';

class ChatMessageComposer extends StatefulWidget {
  const ChatMessageComposer({
    required this.onSendText,
    required this.onSendDocument,
    this.messageSendingEnabled = true,
    this.documentSendingEnabled = true,
    super.key,
  });

  final Future<void> Function(String text) onSendText;
  final Future<void> Function(String documentName) onSendDocument;
  final bool messageSendingEnabled;
  final bool documentSendingEnabled;

  @override
  State<ChatMessageComposer> createState() => _ChatMessageComposerState();
}

class _ChatMessageComposerState extends State<ChatMessageComposer> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.secondary,
        padding: EdgeInsets.fromLTRB(
          12,
          8,
          12,
          MediaQuery.paddingOf(context).bottom + 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            if (widget.documentSendingEnabled) ...<Widget>[
              _ComposerButton(
                key: const ValueKey<String>('attach-document-button'),
                icon: Icons.attach_file_rounded,
                tooltip: 'Add document',
                onTap: _showDocumentOptions,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: TextField(
                key: const ValueKey<String>('chat-message-field'),
                controller: _controller,
                enabled: widget.messageSendingEnabled,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: widget.messageSendingEnabled
                      ? 'Type a message…'
                      : 'Messaging is unavailable for psychologists',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _ComposerButton(
              key: const ValueKey<String>('send-message-button'),
              icon: _sending ? null : Icons.send_rounded,
              tooltip: 'Send message',
              onTap: _sending || !widget.messageSendingEnabled ? null : _send,
              progress: _sending,
              filled: true,
            ),
          ],
        ),
      );

  Future<void> _send() async {
    if (!widget.messageSendingEnabled) return;
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    await widget.onSendText(text);
    if (!mounted) return;
    _controller.clear();
    setState(() => _sending = false);
  }

  Future<void> _showDocumentOptions() async {
    if (!widget.documentSendingEnabled) return;
    final String? documentName = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add a document',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              const Text(
                  'Frontend preview — ready to connect to file storage.'),
              const SizedBox(height: 14),
              _DocumentOption(
                icon: Icons.picture_as_pdf_outlined,
                label: 'Session worksheet.pdf',
                onTap: () => Navigator.of(context).pop('Session worksheet.pdf'),
              ),
              _DocumentOption(
                icon: Icons.image_outlined,
                label: 'Reference image.jpg',
                onTap: () => Navigator.of(context).pop('Reference image.jpg'),
              ),
            ],
          ),
        ),
      ),
    );
    if (documentName != null) await widget.onSendDocument(documentName);
  }
}

class _ComposerButton extends StatelessWidget {
  const _ComposerButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.progress = false,
    this.filled = false,
    super.key,
  });

  final IconData? icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool progress;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final bool disabled = onTap == null && !progress;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: filled
            ? Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: disabled ? .35 : 1)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: SizedBox(
            width: 46,
            height: 46,
            child: progress
                ? const Padding(
                    padding: EdgeInsets.all(13),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    icon,
                    color: filled
                        ? Colors.white.withValues(alpha: disabled ? .7 : 1)
                        : Theme.of(context).colorScheme.primary,
                  ),
          ),
        ),
      ),
    );
  }
}

class _DocumentOption extends StatelessWidget {
  const _DocumentOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: .1),
          foregroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(icon),
        ),
        title: Text(label),
        trailing: const Icon(Icons.add_circle_outline_rounded),
        onTap: onTap,
      );
}
