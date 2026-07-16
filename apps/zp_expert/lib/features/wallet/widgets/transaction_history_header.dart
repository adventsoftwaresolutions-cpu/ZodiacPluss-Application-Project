import 'package:flutter/material.dart';

class TransactionHistoryHeader extends StatelessWidget {
  const TransactionHistoryHeader({
    required this.onDownloadRangeTap,
    super.key,
  });

  final void Function(DateTimeRange range) onDownloadRangeTap;

  @override
  Widget build(BuildContext context) {
    const Widget title = Text(
      'Transaction History',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF2B5A55),
      ),
    );
    final Widget downloadButton = TextButton.icon(
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
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2B5A55)),
      ),
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFDCEAE8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 320) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              title,
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: downloadButton),
            ],
          );
        }

        return Row(
          children: <Widget>[
            const Expanded(child: title),
            const SizedBox(width: 8),
            downloadButton,
          ],
        );
      },
    );
  }
}
