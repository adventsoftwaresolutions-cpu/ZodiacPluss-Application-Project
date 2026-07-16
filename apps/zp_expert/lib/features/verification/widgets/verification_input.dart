import 'package:flutter/material.dart';

class VerificationInput extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final int maxLines;

  const VerificationInput({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  State<VerificationInput> createState() => _VerificationInputState();
}

class _VerificationInputState extends State<VerificationInput> {
  bool _focused = false;
  late final TextEditingController _fallbackController;

  @override
  void initState() {
    super.initState();
    _fallbackController = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant VerificationInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null &&
        widget.initialValue != oldWidget.initialValue &&
        _fallbackController.text != widget.initialValue) {
      final String text = widget.initialValue ?? '';
      _fallbackController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  @override
  void dispose() {
    _fallbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool mobile = MediaQuery.sizeOf(context).width < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xff374151),
          ),
        ),
        const SizedBox(height: 6),
        Focus(
          onFocusChange: (value) {
            setState(() => _focused = value);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _focused
                    ? const Color(0xff18B6A8)
                    : const Color(0xffE5E7EB),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _focused
                      ? const Color(0xff18B6A8).withValues(alpha: .08)
                      : Colors.black.withValues(alpha: .02),
                  blurRadius: _focused ? 18 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: widget.controller ?? _fallbackController,
              onChanged: widget.onChanged,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff111827),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: widget.maxLines == 1 ? (mobile ? 14 : 15) : 16,
                  horizontal: 16,
                ),
                hintText: widget.hint,
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff9CA3AF),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xffECFDFB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.icon,
                      color: const Color(0xff17B3A7),
                      size: 14,
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minHeight: 42,
                  minWidth: 42,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
