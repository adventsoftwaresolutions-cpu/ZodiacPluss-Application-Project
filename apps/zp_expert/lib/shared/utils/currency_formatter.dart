import 'package:intl/intl.dart';

String formatCompactINR(double amount) {
  if (amount >= 10000000) {
    return '₹${(amount / 10000000).toStringAsFixed(2)}Cr';
  } else if (amount >= 100000) {
    return '₹${(amount / 100000).toStringAsFixed(2)}L';
  } else if (amount >= 1000) {
    return NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
        .format(amount);
  }
  return '₹${amount.toStringAsFixed(0)}';
}