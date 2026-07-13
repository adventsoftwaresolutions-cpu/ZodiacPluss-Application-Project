import 'package:flutter/material.dart';

import '../data/schedule_models.dart';

class QueueScheduleView extends StatelessWidget {
  const QueueScheduleView({required this.queue, super.key});

  final List<QueueEntry> queue;

  @override
  Widget build(BuildContext context) {
    if (queue.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text('No one in queue right now',
            style: TextStyle(color: Colors.black45)),
      );
    }

    return Column(
      children: <Widget>[
        for (final QueueEntry entry in queue)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _QueueTile(entry: entry),
          ),
      ],
    );
  }
}

class _QueueTile extends StatelessWidget {
  const _QueueTile({required this.entry});

  final QueueEntry entry;

  @override
  Widget build(BuildContext context) {
    final bool isLoyal = entry.tier == ClientTier.loyal;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2C6E6B)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 40,
            child: Column(
              children: <Widget>[
                Text('#${entry.position}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('pos',
                    style: TextStyle(fontSize: 10, color: Colors.black45)),
              ],
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(entry.clientAvatarUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(entry.clientName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(entry.sessionType.label,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black45)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isLoyal ? const Color(0xFFF3E3C0) : const Color(0xFFE6E0F8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              entry.tier.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isLoyal ? const Color(0xFF8A5B00) : const Color(0xFF3D2E6B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}