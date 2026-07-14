import 'package:flutter/material.dart';
import 'package:zp_expert/shared/utils/currency_formatter.dart';

class TransactionDetailRow extends StatelessWidget {
  const TransactionDetailRow({
    required this.label,
    required this.amount,
    this.isNegative = false,
    super.key,
  });

  final String label;
  final double amount;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    if (amount == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          Text(
            '${isNegative ? '-' : '+'}${formatCompactINR(amount)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isNegative ? Colors.red.shade400 : Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}