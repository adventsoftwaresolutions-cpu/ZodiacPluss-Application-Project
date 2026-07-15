import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zp_expert/features/wallet/data/provider/transaction_history_provider.dart';
import 'package:zp_expert/features/wallet/widgets/payout_assistance_banner.dart';
import 'widgets/stats_row_skeleton.dart';
import 'package:zp_expert/features/wallet/widgets/transaction_card.dart';
import 'package:zp_expert/features/wallet/widgets/transaction_card_skeleton.dart';
import 'package:zp_expert/features/wallet/widgets/transaction_history_header.dart';

import '../../shared/widgets/gradient_page.dart';
import '../../navigation/app_routes.dart';
import 'data/provider/wallet_provider.dart';
import 'widgets/wallet_balance_card.dart';
import 'widgets/stats_row.dart';
import 'widgets/wallet_header.dart';
import 'widgets/wallet_card_error.dart';
import 'widgets/wallet_card_skeleton.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(transactionHistoryProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletProvider);
    final historyAsync = ref.watch(transactionHistoryProvider);

    return GradientPage(
      child: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: WalletHeader(
                  onNotificationTap: () {}, // TODO: wire notification route
                  onChatTap: () {}, // TODO: wire chat route
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              sliver: SliverToBoxAdapter(
                child: walletAsync.when(
                  data: (wallet) => WalletBalanceCard(
                    totalBalance: wallet.totalBalance,
                    availableBalance: wallet.availableBalance,
                    monthlyEarnings: wallet.monthlyEarnings,
                  ),
                  loading: () => const WalletCardSkeleton(),
                  error: (err, stack) => WalletCardError(
                    message: "Failed to load wallet data.",
                    onRetry: () => ref.invalidate(walletProvider),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverToBoxAdapter(
                child: walletAsync.when(
                  data: (wallet) => StatsRow(
                    totalWithdraw: wallet.totalWithdraw,
                    sessionsCompleted: wallet.sessionsCompleted,
                    avgEarningPerSession: wallet.avgEarningPerSession,
                  ),
                  loading: () => const StatsRowSkeleton(),
                  error: (err, stack) => const SizedBox.shrink(),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverToBoxAdapter(
                child: PayoutAssistanceBanner(
                  onGetAssistanceTap: () => context.push(ExpertRoutes.contact),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              sliver: SliverToBoxAdapter(
                child: TransactionHistoryHeader(
                  onDownloadRangeTap: (range) {
                    // TODO: implement actual export — fetch transactions in
                    // [range.start, range.end] from repository, generate
                    // PDF/CSV, trigger device save/share. Deferred per instruction,
                    // same as per-transaction receipt download.
                    debugPrint(
                        'Download requested: ${range.start} → ${range.end}');
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              sliver: historyAsync.when(
                data: (state) {
                  if (state.items.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text('No transactions yet',
                              style: TextStyle(color: Colors.black45)),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == state.items.length) {
                          return _buildFooter(state);
                        }
                        return TransactionCard(transaction: state.items[index]);
                      },
                      childCount: state.items.length + 1,
                    ),
                  );
                },
                loading: () => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const TransactionCardSkeleton(),
                    childCount: 5,
                  ),
                ),
                error: (err, stack) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          const Text("Couldn't load transactions",
                              style: TextStyle(color: Colors.black54)),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () =>
                                ref.invalidate(transactionHistoryProvider),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(dynamic state) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (state.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: TextButton(
            onPressed: () =>
                ref.read(transactionHistoryProvider.notifier).loadMore(),
            child: const Text('Retry loading more'),
          ),
        ),
      );
    }
    if (!state.hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text("You've reached the beginning",
              style: TextStyle(fontSize: 12, color: Colors.black38)),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
