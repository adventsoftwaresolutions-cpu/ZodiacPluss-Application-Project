import '../model/transaction_model.dart';

class TransactionPage {
  const TransactionPage({required this.items, required this.hasMore});
  final List<TransactionModel> items;
  final bool hasMore;
}

abstract class TransactionRepositorySupabase {
  // TODO: Migrate to cursor-based pagination before wiring real Supabase.

  // TODO: Add filter/search support (dateRange, query) — required for
  // both future search/filter UI AND for the date-range "Download all"
  // export feature, which needs to fetch a full unpaginated range rather
  // than page-by-page. Likely needs a second method, e.g.
  // fetchTransactionsInRange(DateTimeRange range) — bypasses pagination
  // entirely since exports need the complete dataset for that window.
  Future<TransactionPage> fetchTransactions({required int page, required int pageSize});
}

abstract class TransactionRepository {
  Future<TransactionPage> fetchTransactions({required int page, required int pageSize});
}

/// Temporary in-memory implementation. Simulates real pagination against
/// a fixed dataset so the lazy-load UI is actually exercised during dev,
/// not just assumed to work once Supabase exists. Replace with a
/// Supabase-backed implementation later — provider and UI stay untouched.
class StubTransactionRepository implements TransactionRepository {
  static final List<TransactionModel> _allTransactions = List.generate(
    47, // deliberately not a clean multiple of pageSize, to exercise the
        // "last page is partial" edge case your UI must handle correctly
    (int i) {
      final bool isCharge = i % 5 == 0;
      return TransactionModel(
        id: 'txn_$i',
        type: isCharge ? TransactionType.platformCharge : TransactionType.sessionEarning,
        status: i % 13 == 0 ? TransactionStatus.pending : TransactionStatus.completed,
        title: isCharge ? 'Platform charges' : 'Session earnings',
        grossAmount: isCharge ? 0 : 1700,
        tax: isCharge ? 0 : 150,
        platformFee: isCharge ? 225 : 50,
        bonus: (i % 7 == 0 && !isCharge) ? 100 : 0,
        timestamp: DateTime(2026, 7, 14).subtract(Duration(days: i)),
      );
    },
  );

  @override
  Future<TransactionPage> fetchTransactions({
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final int start = page * pageSize;
    if (start >= _allTransactions.length) {
      return const TransactionPage(items: <TransactionModel>[], hasMore: false);
    }

    final int end = (start + pageSize).clamp(0, _allTransactions.length);
    final List<TransactionModel> slice = _allTransactions.sublist(start, end);

    return TransactionPage(items: slice, hasMore: end < _allTransactions.length);
  }
}