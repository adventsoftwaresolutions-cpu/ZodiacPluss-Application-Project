import 'package:flutter/material.dart';

enum _OfflineOption { thirtyMin, oneHour, twoHour, tomorrow, custom }

/// Returns the DateTime the expert expects to be back online,
/// or null if the user cancelled the offline transition.
Future<DateTime?> showGoOfflineSheet(BuildContext context) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext context) => const _GoOfflineSheetContent(),
  );
}

class _GoOfflineSheetContent extends StatefulWidget {
  const _GoOfflineSheetContent();

  @override
  State<_GoOfflineSheetContent> createState() => _GoOfflineSheetContentState();
}

class _GoOfflineSheetContentState extends State<_GoOfflineSheetContent> {
  _OfflineOption? _selected;
  late DateTime _customDate = DateTime.now();
  late TimeOfDay _customTime = TimeOfDay.now();

  bool get _isCustomExpanded => _selected == _OfflineOption.custom;

  DateTime? _resolveReturnTime() {
    final DateTime now = DateTime.now();
    switch (_selected) {
      case _OfflineOption.thirtyMin:
        return now.add(const Duration(minutes: 30));
      case _OfflineOption.oneHour:
        return now.add(const Duration(hours: 1));
      case _OfflineOption.twoHour:
        return now.add(const Duration(hours: 2));
      case _OfflineOption.tomorrow:
        return DateTime(now.year, now.month, now.day + 1, 9);
      case _OfflineOption.custom:
        return DateTime(
          _customDate.year,
          _customDate.month,
          _customDate.day,
          _customTime.hour,
          _customTime.minute,
        );
      case null:
        return null;
    }
  }

  Future<void> _pickCustomDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _customDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() => _customDate = picked);
    }
  }

  Future<void> _pickCustomTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _customTime,
    );
    if (picked != null) {
      setState(() => _customTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? returnTime = _resolveReturnTime();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(width: 32),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCEAE8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.access_time_rounded,
                      color: Color(0xFF2C6E6B)),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.cancel, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'When will you be next online?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'You can switch back online at any time',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _OptionTile(
              label: 'In 30 minutes',
              selected: _selected == _OfflineOption.thirtyMin,
              onTap: () => setState(() => _selected = _OfflineOption.thirtyMin),
            ),
            const SizedBox(height: 10),
            _OptionTile(
              label: 'In 1 hour',
              selected: _selected == _OfflineOption.oneHour,
              onTap: () => setState(() => _selected = _OfflineOption.oneHour),
            ),
            const SizedBox(height: 10),
            _OptionTile(
              label: 'In 2 hours',
              selected: _selected == _OfflineOption.twoHour,
              onTap: () => setState(() => _selected = _OfflineOption.twoHour),
            ),
            const SizedBox(height: 10),
            _OptionTile(
              label: 'Tomorrow',
              selected: _selected == _OfflineOption.tomorrow,
              onTap: () => setState(() => _selected = _OfflineOption.tomorrow),
            ),
            const SizedBox(height: 10),
            _OptionTile(
              label: 'Custom time',
              selected: _selected == _OfflineOption.custom,
              onTap: () => setState(() => _selected = _OfflineOption.custom),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _isCustomExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: _PickerField(
                              label: 'Date',
                              icon: Icons.calendar_today_rounded,
                              value:
                                  '${_customDate.day} ${_monthName(_customDate.month)} ${_customDate.year}',
                              onTap: _pickCustomDate,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _PickerField(
                              label: 'Time',
                              icon: Icons.access_time_rounded,
                              value: _customTime.format(context),
                              onTap: _pickCustomTime,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: returnTime == null
                    ? null
                    : () => Navigator.of(context).pop(returnTime),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _monthName(int month) {
  const List<String> months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? const Color(0xFF2C6E6B) : Colors.grey.shade300,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: selected ? const Color(0xFF2C6E6B) : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                Icon(icon, size: 16, color: const Color(0xFF2C6E6B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(value,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
