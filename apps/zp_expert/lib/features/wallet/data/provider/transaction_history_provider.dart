import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zp_expert/features/wallet/data/model/transaction_model.dart';
import '../model/transaction_history_state.dart';
import 'package:zp_expert/features/wallet/data/repository/transaction_repository.dart';

const int transactionPageSize = 20;

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return StubTransactionRepository();
});

final transactionHistoryProvider =
    AsyncNotifierProvider<TransactionHistoryNotifier, TransactionHistoryState>(
  TransactionHistoryNotifier.new,
);

class TransactionHistoryNotifier extends AsyncNotifier<TransactionHistoryState> {
  @override
  Future<TransactionHistoryState> build() async {
    final TransactionRepository repository = ref.watch(transactionRepositoryProvider);
    final TransactionPage page = await repository.fetchTransactions(
      page: 0,
      pageSize: transactionPageSize,
    );

    return TransactionHistoryState(
      items: page.items,
      hasMore: page.hasMore,
      currentPage: 0,
    );
  }

  /// Fetches the next page and appends it. Safe to call repeatedly from a
  /// scroll listener — guards against duplicate in-flight requests and
  /// calling past the end of the dataset.
  Future<void> loadMore() async {
    final TransactionHistoryState? current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    try {
      final TransactionRepository repository = ref.read(transactionRepositoryProvider);
      final int nextPage = current.currentPage + 1;
      final TransactionPage page = await repository.fetchTransactions(
        page: nextPage,
        pageSize: transactionPageSize,
      );

      state = AsyncData(
        current.copyWith(
          items: <TransactionModel>[...current.items, ...page.items],
          hasMore: page.hasMore,
          currentPage: nextPage,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: e.toString()),
      );
    }
  }

  /// Full reset — pull-to-refresh. Deliberately re-runs build() from
  /// page 0 rather than trying to merge/diff against existing items;
  /// simpler and correct even if new transactions arrived at the top.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}