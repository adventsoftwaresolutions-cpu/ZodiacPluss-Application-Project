import '../model/wallet_model.dart';

abstract class WalletRepository {
  Future<WalletModel> fetchWallet();
}

/// Temporary in-memory implementation. Replace with a Supabase-backed
/// implementation later — the provider and every widget above it should
/// not need to change when that happens, only this class.
class StubWalletRepository implements WalletRepository {
  @override
  Future<WalletModel> fetchWallet() async {
    // Simulated latency so the loading state in WalletPage is actually
    // exercised during dev instead of always resolving instantly.
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return const WalletModel(
      totalBalance: 24850000,
      availableBalance: 18400,
      monthlyEarnings: 6450,
    );
  }
}