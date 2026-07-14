import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'schedule_card_skeleton.dart';
import '../data/schedule_controller.dart';
import '../data/schedule_models.dart';
import 'appointment_schedule_view.dart';
import 'queue_schedule_view.dart';

class ScheduleCard extends ConsumerWidget {
  const ScheduleCard({required this.onViewAllTap, super.key});

  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ScheduleViewData> data =
        ref.watch(scheduleViewDataProvider);

    final String title = switch (data.valueOrNull) {
      QueueScheduleData() => 'Queue',
      _ => 'Schedule',
    };

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D3B3E),
                ),
              ),
              InkWell(
                onTap: onViewAllTap,
                child: const Text('View All',
                    style: TextStyle(fontSize: 14, color: Color(0xFF0D3B3E))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          data.when(
            data: (ScheduleViewData value) => switch (value) {
              AppointmentScheduleData(:final appointments) =>
                AppointmentScheduleView(appointments: appointments),
              QueueScheduleData(:final queue) =>
                QueueScheduleView(queue: queue),
            },
            loading: () => const ScheduleCardSkeleton(),
            error: (Object error, StackTrace stackTrace) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text('Unable to load schedule',
                  style: TextStyle(color: Colors.red, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}