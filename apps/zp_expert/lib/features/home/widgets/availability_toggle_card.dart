import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/availability_controller.dart';
import '../data/availability_status.dart';
import 'go_offline_sheet.dart';

class AvailabilityToggleCard extends ConsumerWidget {
  const AvailabilityToggleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AvailabilityStatus status =
        ref.watch(availabilityControllerProvider);
    final AvailabilityController controller =
        ref.read(availabilityControllerProvider.notifier);

    return Row(
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFDCEAE8),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.circle,
            size: 14,
            color: status.isOnline ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                status.isOnline ? 'You are online' : 'You are offline',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: status.isOnline ? Colors.green : Colors.black54,
                ),
              ),
              Text(
                status.isOnline
                    ? 'You are visible to clients'
                    : 'Back at ${_formatTime(status.offlineUntil)}',
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ),
        Switch(
          value: status.isOnline,
            activeThumbColor: const Color(0xFF2C6E6B),
            activeTrackColor: const Color(0xFF2C6E6B).withValues(alpha: 0.5),
          onChanged: (bool goingOnline) async {
            if (goingOnline) {
              await controller.goOnline();
              return;
            }
            // Intercept: do NOT flip state until the user confirms a
            // return time. If they cancel, the Switch simply doesn't
            // rebuild, since `status` in the provider never changed.
            final DateTime? returnTime = await showGoOfflineSheet(context);
            if (returnTime != null) {
              await controller.goOffline(returnTime);
            }
          },
        ),
      ],
    );
  }
}

String _formatTime(DateTime? time) {
  if (time == null) {
    return '—';
  }
  final int hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final String period = time.hour >= 12 ? 'PM' : 'AM';
  final String minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute $period';
}