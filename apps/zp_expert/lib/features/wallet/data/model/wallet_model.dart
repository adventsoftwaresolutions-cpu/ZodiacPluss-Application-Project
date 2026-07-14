class WalletModel {
  const WalletModel({
    required this.totalBalance,
    required this.availableBalance,
    required this.monthlyEarnings,
    required this.totalWithdraw,
    required this.sessionsCompleted,
    required this.avgEarningPerSession,
  });

  final double totalBalance;
  final double availableBalance;
  final double monthlyEarnings;
  final double totalWithdraw;
  final int sessionsCompleted;
  final double avgEarningPerSession;
}