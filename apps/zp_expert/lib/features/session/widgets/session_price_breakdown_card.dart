import 'package:flutter/material.dart';

import '../../../shared/utils/currency_formatter.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import '../../wallet/widgets/transaction_detail_row.dart';
import '../data/models/session_history_model.dart';

class SessionPriceBreakdownCard extends StatelessWidget {
  const SessionPriceBreakdownCard({required this.detail, super.key});

  final SessionDetailModel detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Price Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.ticketText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          TransactionDetailRow(
              label: 'Actual cost', amount: detail.grossAmount),
          TransactionDetailRow(
              label: 'Taxes', amount: detail.tax, isNegative: true),
          TransactionDetailRow(
            label: 'Platform fee',
            amount: detail.platformFee,
            isNegative: true,
          ),
          TransactionDetailRow(label: 'Bonus', amount: detail.bonus),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 9),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Net earnings',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                formatCompactINR(detail.netEarnings),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.ticketResolved,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
