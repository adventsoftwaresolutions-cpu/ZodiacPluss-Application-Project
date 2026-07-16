import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'availability_schedule_card_skeleton.dart';
import '../data/weekly_availability.dart';
import '../data/weekly_availability_controller.dart';

class AvailabilityScheduleCard extends ConsumerWidget {
  const AvailabilityScheduleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<WeeklyAvailability> scheduleState =
        ref.watch(weeklyAvailabilityControllerProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _CardHeader(),
          const SizedBox(height: 8),
          const Divider(height: 1),
          scheduleState.when(
            data: (WeeklyAvailability schedule) =>
                _ScheduleRows(schedule: schedule),
            loading: () => const AvailabilityScheduleCardSkeleton(),
            error: (Object error, StackTrace stackTrace) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Unable to load availability',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFDCEAE8),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/calendar.svg',
            width: 25,
            height: 25,
            colorFilter: const ColorFilter.mode(
              Color(0xFF2C6E6B),
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Availability',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D3B3E),
              ),
            ),
            Text(
              'Set weekly and daily availability',
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ],
        ),
      ],
    );
  }
}

class _ScheduleRows extends ConsumerWidget {
  const _ScheduleRows({required this.schedule});

  final WeeklyAvailability schedule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WeeklyAvailabilityController controller =
        ref.read(weeklyAvailabilityControllerProvider.notifier);

    return Column(
      children: <Widget>[
        for (final DaySchedule day in schedule.days)
          _DayRow(
            day: day,
            onToggle: (bool value) => controller.toggleDay(day.weekday, value),
            onFromChanged: (AvailabilityTime t) =>
                controller.updateFrom(day.weekday, t),
            onToChanged: (AvailabilityTime t) =>
                controller.updateTo(day.weekday, t),
          ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final bool success = await controller.save();
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Availability updated'
                        : 'Failed to update availability',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.day,
    required this.onToggle,
    required this.onFromChanged,
    required this.onToChanged,
  });

  final DaySchedule day;
  final ValueChanged<bool> onToggle;
  final ValueChanged<AvailabilityTime> onFromChanged;
  final ValueChanged<AvailabilityTime> onToChanged;

  Future<void> _pick(
    BuildContext context,
    AvailabilityTime current,
    ValueChanged<AvailabilityTime> onChanged,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current.hour, minute: current.minute),
    );
    if (picked != null) {
      onChanged(AvailabilityTime(hour: picked.hour, minute: picked.minute));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double opacity = day.isEnabled ? 1.0 : 0.5;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Opacity(
        opacity: opacity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 90,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Text(
                      day.weekday.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D3B3E),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 2, bottom: 4),
                        child: Text(
                          'From',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      _TimeField(
                        value: day.from.formatted,
                        enabled: day.isEnabled,
                        onTap: () =>
                            _pick(context, day.from, onFromChanged),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 2, bottom: 4),
                        child: Text(
                          'To',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      _TimeField(
                        value: day.to.formatted,
                        enabled: day.isEnabled,
                        onTap: () => _pick(context, day.to, onToChanged),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Switch(
                    value: day.isEnabled,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: onToggle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.value,
    required this.enabled,
    required this.onTap,
  });

  final String value;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.access_time_rounded,
              size: 14,
              color: Color(0xFF2C6E6B),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}