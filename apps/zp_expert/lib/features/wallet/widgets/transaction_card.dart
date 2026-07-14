import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/model/transaction_model.dart';
import 'package:zp_expert/features/wallet/widgets/transaction_detail_row.dart';
import 'package:zp_expert/shared/utils/currency_formatter.dart';

class TransactionCard extends StatefulWidget {
  const TransactionCard({required this.transaction, super.key});

  final TransactionModel transaction;

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final TransactionModel txn = widget.transaction;
    final bool credit = txn.isCredit;
    final Color directionColor = credit ? Colors.green.shade700 : Colors.red.shade400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: directionColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    credit ? Icons.arrow_upward : Icons.arrow_downward,
                    color: directionColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        txn.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _statusLabel(txn.status),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _statusColor(txn.status),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat("d-MMM-yyyy, h:mma").format(txn.timestamp).toLowerCase(),
                        style: const TextStyle(fontSize: 11.5, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatCompactINR(txn.netAmount.abs()),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: directionColor,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCEAE8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF2B5A55)),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _expanded ? _buildBreakdown(txn) : const SizedBox(width: double.infinity),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildBreakdown(TransactionModel txn) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 56, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TransactionDetailRow(label: 'Gross amount', amount: txn.grossAmount),
          TransactionDetailRow(label: 'Tax', amount: txn.tax, isNegative: true),
          TransactionDetailRow(label: 'Platform fee', amount: txn.platformFee, isNegative: true),
          TransactionDetailRow(label: 'Bonus', amount: txn.bonus),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Net amount', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              Text(
                formatCompactINR(txn.netAmount.abs()),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF2B5A55)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                // TODO: implement receipt download/export (deferred per instruction)
              },
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Download Receipt', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'Payment received';
      case TransactionStatus.pending:
        return 'Pending settlement';
      case TransactionStatus.failed:
        return 'Payment failed';
    }
  }

  Color _statusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return Colors.green.shade700;
      case TransactionStatus.pending:
        return Colors.orange.shade700;
      case TransactionStatus.failed:
        return Colors.red.shade400;
    }
  }
}