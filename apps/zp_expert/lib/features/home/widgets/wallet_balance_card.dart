import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/wallet_repository.dart';
import '../../../shared/constans/app_assets.dart';

class WalletBalanceCard extends ConsumerWidget {
  const WalletBalanceCard({required this.onCheckStatus, super.key});

  final VoidCallback onCheckStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<double> balance = ref.watch(walletBalanceProvider);
    final NumberFormat formatter =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    return Row(
      children: <Widget>[
        SvgPicture.asset(
          AppAssets.walletIcon,
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Wallet Balance',
                  style: TextStyle(fontSize: 14, color: Colors.black)),
              const SizedBox(height: 2),
              balance.when(
                data: (double value) => Text(
                  formatter.format(value),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C6E6B),
                  ),
                ),
                loading: () => const SizedBox(
                  height: 26,
                  width: 26,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (Object error, StackTrace stackTrace) => const Text(
                  'Unable to load balance',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onCheckStatus,
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFD6E9E7),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Check Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C6E6B),
            ),
          ),
        ),
      ],
    );
  }
}
