import 'package:flutter/material.dart';

/// Returns the DateTime the expert expects to be back online,
/// or null if the user cancelled the offline transition.
Future<DateTime?> showGoOfflineSheet(BuildContext context) {
  return showModalBottomSheet<DateTime>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) => const _GoOfflineSheetContent(),
  );
}

class _GoOfflineSheetContent extends StatelessWidget {
  const _GoOfflineSheetContent();

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    final List<_QuickOption> options = <_QuickOption>[
      _QuickOption('1 hour', now.add(const Duration(hours: 1))),
      _QuickOption('4 hours', now.add(const Duration(hours: 4))),
      _QuickOption(
        'Tomorrow 9 AM',
        DateTime(now.year, now.month, now.day + 1, 9),
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'When will you be back online?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Clients will see you as offline until this time.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            for (final _QuickOption option in options)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule_rounded),
                title: Text(option.label),
                onTap: () => Navigator.of(context).pop(option.time),
              ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.edit_calendar_rounded),
              title: const Text('Pick custom time'),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(now),
                );
                if (picked == null || !context.mounted) {
                  return;
                }
                final DateTime customTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  picked.hour,
                  picked.minute,
                );
                Navigator.of(context).pop(customTime);
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickOption {
  const _QuickOption(this.label, this.time);
  final String label;
  final DateTime time;
}