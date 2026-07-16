import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/schedule_controller.dart';
import '../data/schedule_models.dart';

class AppointmentScheduleView extends StatelessWidget {
  const AppointmentScheduleView({required this.appointments, super.key});

  final List<AppointmentEntry> appointments;

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text('No upcoming appointments',
            style: TextStyle(color: Colors.black45)),
      );
    }

    return Column(
      children: <Widget>[
        for (final AppointmentEntry appointment in appointments)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _AppointmentTile(appointment: appointment),
          ),
      ],
    );
  }
}

class _AppointmentTile extends ConsumerWidget {
  const _AppointmentTile({required this.appointment});

  final AppointmentEntry appointment;

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Cancel appointment?'),
        content: Text(
          'This will cancel the session with ${appointment.clientName}. This cannot be undone.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel session',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(scheduleActionsControllerProvider.notifier)
          .cancelAppointment(appointment.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = appointment.scheduledAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(_formatDate(date),
            style: const TextStyle(fontSize: 12, color: Colors.black45)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF2C6E6B)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget details = _AppointmentDetails(
                appointment: appointment,
                date: date,
              );
              final Widget actions = _AppointmentActions(
                onCancel: () => _confirmCancel(context, ref),
              );

              if (constraints.maxWidth < 300) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    details,
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerRight, child: actions),
                  ],
                );
              }

              return Row(
                children: <Widget>[
                  Expanded(child: details),
                  const SizedBox(width: 8),
                  actions,
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AppointmentDetails extends StatelessWidget {
  const _AppointmentDetails({
    required this.appointment,
    required this.date,
  });

  final AppointmentEntry appointment;
  final DateTime date;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          SizedBox(
            width: 64,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _formatTime(date),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${appointment.duration.inMinutes} min',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5A6B8C),
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(appointment.clientAvatarUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  appointment.clientName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  appointment.sessionType.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _AppointmentActions extends StatelessWidget {
  const _AppointmentActions({required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Text(
            'Upcoming',
            style: TextStyle(fontSize: 12, color: Color(0xFF0D3B3E)),
          ),
          const SizedBox(height: 6),
          OutlinedButton.icon(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            ),
            icon: const Icon(Icons.close, size: 12, color: Colors.red),
            label: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      );
}

String _formatDate(DateTime date) {
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
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String _formatTime(DateTime date) {
  final int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final String period = date.hour >= 12 ? 'PM' : 'AM';
  final String minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute $period';
}
