import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zp_expert/features/wallet/widgets/payout_assistance_banner.dart';

import '../../shared/widgets/gradient_page.dart';
import 'data/provider/wallet_provider.dart';
import 'widgets/wallet_balance_card.dart';
import 'widgets/wallet_header.dart';

class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletProvider);

    return GradientPage(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              WalletHeader(
                onBackTap: () => Navigator.of(context).pop(),
                onNotificationTap: () {}, // TODO: wire notification route
                onChatTap: () {}, // TODO: wire chat route
              ),
              const SizedBox(height: 24),
              walletAsync.when(
                data: (wallet) => WalletBalanceCard(
                  totalBalance: wallet.totalBalance,
                  availableBalance: wallet.availableBalance,
                  monthlyEarnings: wallet.monthlyEarnings,
                ),
                loading: () => const _WalletCardSkeleton(),
                error: (err, stack) => _WalletCardError(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(walletProvider),
                ),
              ),
              const SizedBox(height: 20),
              PayoutAssistanceBanner(
                onGetAssistanceTap: () {}, // TODO: wire assistance or contact route
              ),

              // Upcoming widgets
              // SizedBox(height: 16),
              // TransactionHistoryCard(),
            ],
          ),
        ),
      ),
    );
  }
}

//Wallet skeleton and error widgets
class _WalletCardSkeleton extends StatelessWidget {
  const _WalletCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white70),
      ),
    );
  }
}

class _WalletCardError extends StatelessWidget {
  const _WalletCardError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            const Text(
              "Couldn't load your wallet",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}