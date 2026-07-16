import 'package:flutter/material.dart';

class VerificationDropdown<T> extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;

  const VerificationDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  State<VerificationDropdown<T>> createState() =>
      _VerificationDropdownState<T>();
}

class _VerificationDropdownState<T> extends State<VerificationDropdown<T>> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
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
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _focused
                    ? const Color(0xff18B6A8)
                    : const Color(0xffE5E7EB),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _focused
                      ? const Color(0xff18B6A8).withValues(alpha: .06)
                      : Colors.black.withValues(alpha: .015),
                  blurRadius: _focused ? 12 : 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonFormField<T>(
              key: ValueKey<T?>(widget.value),
              initialValue: widget.value,
              items: widget.items,
              onChanged: widget.onChanged,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xff111827),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: Color(0xff9CA3AF),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                hintText: widget.hint,
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff9CA3AF),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xffECFDFB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 13,
                      color: const Color(0xff18B6A8),
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
