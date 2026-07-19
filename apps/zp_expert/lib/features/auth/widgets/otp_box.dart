import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpBox extends StatefulWidget {
  const OtpBox({
    required this.controller,
    required this.focusNode,
    this.onDigitEntered,
    this.onBackspaceWhenEmpty,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onDigitEntered;
  final VoidCallback? onBackspaceWhenEmpty;

  @override
  State<OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<OtpBox> {
  bool _focused = false;
  late String _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.controller.text;

    widget.focusNode.addListener(() {
      if (!mounted) return;

      setState(() {
        _focused = widget.focusNode.hasFocus;
      });
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    final bool isEmptyBackspace = event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        widget.controller.text.isEmpty;
    if (!isEmptyBackspace) return KeyEventResult.ignored;

    widget.onBackspaceWhenEmpty?.call();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      height: 62,
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _focused
              ? colors.primary
              : colors.onSurface.withValues(alpha: .14),
          width: _focused ? 2 : 1,
        ),
        boxShadow: [
          if (_focused)
            BoxShadow(
              color: colors.primary.withValues(alpha: .18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Focus(
        onKeyEvent: _handleKeyEvent,
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ).copyWith(color: colors.onSurface),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: (String value) {
            final bool didEraseDigit =
                value.isEmpty && _previousValue.isNotEmpty;
            _previousValue = value;
            if (value.isNotEmpty) {
              widget.onDigitEntered?.call();
            } else if (didEraseDigit) {
              widget.onBackspaceWhenEmpty?.call();
            }
          },
        ),
      ),
    );
  }
}
