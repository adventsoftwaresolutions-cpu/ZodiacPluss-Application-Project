import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/dev/stimulated_latency.dart';

abstract class WalletRepository {
  Future<double> fetchBalance();
}

/// Placeholder until the real wallet API is wired in.
class MockWalletRepository implements WalletRepository {
  @override
  Future<double> fetchBalance() async {
    await simulateNetworkLatency();
    return 72000;
  }
}

final Provider<WalletRepository> walletRepositoryProvider =
    Provider<WalletRepository>((Ref ref) => MockWalletRepository());

final FutureProvider<double> walletBalanceProvider =
    FutureProvider<double>((Ref ref) {
  return ref.watch(walletRepositoryProvider).fetchBalance();
});