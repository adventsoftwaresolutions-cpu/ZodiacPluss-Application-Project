import 'package:flutter/material.dart';

class TransactionHistoryHeader extends StatelessWidget {
  const TransactionHistoryHeader({
    required this.onDownloadRangeTap,
    super.key,
  });

  final void Function(DateTimeRange range) onDownloadRangeTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Transaction History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF2B5A55)),
        ),
        TextButton.icon(
          onPressed: () async {
            final DateTimeRange? range = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2024),
              lastDate: DateTime.now(),
              initialDateRange: DateTimeRange(
                start: DateTime.now().subtract(const Duration(days: 30)),
                end: DateTime.now(),
              ),
            );
            if (range != null) onDownloadRangeTap(range);
          },
          icon: const Icon(Icons.download, size: 16, color: Color(0xFF2B5A55)),
          label: const Text(
            'Download',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF2B5A55)),
          ),
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFDCEAE8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }
}