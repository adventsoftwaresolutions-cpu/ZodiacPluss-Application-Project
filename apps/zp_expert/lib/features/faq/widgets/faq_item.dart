import 'package:flutter/material.dart';

import '../data/faq_model.dart';

class FaqItem extends StatelessWidget {
  const FaqItem({
    required this.faq,
    required this.onTap,
    super.key,
  });

  final FaqModel faq;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      faq.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: faq.isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colors.primary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: ClipRect(
              child: Align(
                alignment: Alignment.topLeft,
                heightFactor: faq.isExpanded ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    0,
                    18,
                    18,
                  ),
                  child: Text(
                    faq.answer,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: colors.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
