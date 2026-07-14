import 'package:flutter/material.dart';
import 'package:zp_expert/shared/utils/currency_formatter.dart';

class BalanceInfo extends StatelessWidget {
  const BalanceInfo({
    required this.label,
    required this.amount,
    this.dotColor,
    this.caption,
    super.key,
  });

  final String label;
  final double amount;
  final Color? dotColor;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 18, // forces equal label height so both columns align
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: <Widget>[
            Text(
              formatCompactINR(amount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (dotColor != null) ...<Widget>[
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
        if (caption != null) ...<Widget>[
          const SizedBox(height: 2),
          Text(caption!,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ],
    );
  }
}
