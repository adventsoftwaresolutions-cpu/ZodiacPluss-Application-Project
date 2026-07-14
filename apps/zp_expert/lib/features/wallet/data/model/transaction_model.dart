enum TransactionStatus { completed, pending, failed }

enum TransactionType { sessionEarning, chatEarning, platformCharge, bonus, payout }

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.grossAmount,
    required this.tax,
    required this.platformFee,
    required this.bonus,
    required this.timestamp,
  });

  final String id;
  final TransactionType type;
  final TransactionStatus status;
  final String title;
  final double grossAmount;
  final double tax;
  final double platformFee;
  final double bonus;
  final DateTime timestamp;

  /// Single source of truth for the settled amount. Never store this
  /// separately — always derive it, or it will drift from its inputs
  /// the moment any one of them changes upstream.
  double get netAmount => grossAmount - tax - platformFee + bonus;

  /// Positive net = money in (green, up arrow). Negative = money out
  /// (red, down arrow). Drives icon/color in the UI without the UI
  /// needing to know the type-to-direction mapping itself.
  bool get isCredit => netAmount >= 0;
}