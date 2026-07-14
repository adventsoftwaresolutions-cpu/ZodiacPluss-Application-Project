import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/provider/transaction_history_provider.dart';
import 'package:zp_expert/features/wallet/widgets/transaction_card.dart';

class TransactionHistoryList extends ConsumerStatefulWidget {
  const TransactionHistoryList({super.key});

  @override
  ConsumerState<TransactionHistoryList> createState() => _TransactionHistoryListState();
}

class _TransactionHistoryListState extends ConsumerState<TransactionHistoryList> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    // Trigger loadMore() when the user is within 300px of the bottom,
    // not exactly at the bottom — feels less abrupt than waiting for
    // the absolute scroll limit.
    if (_controller.position.pixels >= _controller.position.maxScrollExtent - 300) {
      ref.read(transactionHistoryProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<dynamic> historyAsync = ref.watch(transactionHistoryProvider);

    return historyAsync.when(
      data: (state) {
        if (state.items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text('No transactions yet', style: TextStyle(color: Colors.black45)),
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (_) => false,
          child: ListView.builder(
            controller: _controller,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.items.length + 1,
            itemBuilder: (context, index) {
              if (index == state.items.length) {
                return _buildFooter(state);
              }
              return TransactionCard(transaction: state.items[index]);
            },
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: <Widget>[
              const Text("Couldn't load transactions", style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(transactionHistoryProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
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
            onPressed: () => ref.read(transactionHistoryProvider.notifier).loadMore(),
            child: const Text('Retry loading more'),
          ),
        ),
      );
    }
    if (!state.hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text("You've reached the beginning", style: TextStyle(fontSize: 12, color: Colors.black38)),
        ),
      );
    }
    return const SizedBox.shrink();
  }
} 