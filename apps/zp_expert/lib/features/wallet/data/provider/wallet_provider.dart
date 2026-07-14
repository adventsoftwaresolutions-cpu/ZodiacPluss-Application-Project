import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/wallet_model.dart';
import 'package:zp_expert/features/wallet/data/repository/wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return StubWalletRepository();
});

final walletProvider = FutureProvider<WalletModel>((ref) async {
  final repository = ref.watch(walletRepositoryProvider);
  return repository.fetchWallet();
});