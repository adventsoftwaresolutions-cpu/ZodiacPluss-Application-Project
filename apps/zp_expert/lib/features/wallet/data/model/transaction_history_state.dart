import 'transaction_model.dart';

class TransactionHistoryState {
  const TransactionHistoryState({
    required this.items,
    required this.hasMore,
    required this.currentPage,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<TransactionModel> items;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;

  /// Error from a loadMore() call specifically — kept separate from the
  /// initial-load error (which AsyncValue.error already handles via the
  /// notifier's build()). This lets the UI show existing items AND an
  /// inline "couldn't load more, retry" without wiping the list the
  /// user already scrolled through.
  final String? loadMoreError;

  TransactionHistoryState copyWith({
    List<TransactionModel>? items,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return TransactionHistoryState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
    );
  }
}