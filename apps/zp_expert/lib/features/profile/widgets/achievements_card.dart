import 'package:flutter/material.dart';

import 'profile_section_card.dart';

class AchievementsCard extends StatelessWidget {
  const AchievementsCard({super.key});

  @override
  Widget build(BuildContext context) => const ProfileSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileSectionTitle(
              icon: Icons.emoji_events_outlined,
              title: 'Achievements',
            ),
            Padding(
              padding: EdgeInsets.only(left: 33),
              child: Text('Your monthly progress',
                  style: TextStyle(color: Colors.black45, fontSize: 12)),
            ),
            SizedBox(height: 16),
            _ProgressTrack(),
            SizedBox(height: 16),
            _AchievementRow(
              label: 'Level 1: Verified',
              status: 'Completed',
              statusIcon: Icons.check_circle_outline,
            ),
            _AchievementRow(
              label: 'Level 2: Earn ₹5000+ this month',
              status: 'Completed',
              statusIcon: Icons.check_circle_outline,
            ),
            _AchievementRow(
              label: 'Level 3: Earn ₹10000+ this month',
              status: 'In Progress',
              statusIcon: Icons.bar_chart_rounded,
            ),
            _AchievementRow(
              label: 'Level 4: Earn ₹20000+ this month',
              status: 'Locked',
              statusIcon: Icons.lock_outline_rounded,
              isLocked: true,
            ),
          ],
        ),
      );
}

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack();

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Level 1', style: TextStyle(fontSize: 11)),
              Text('Level 2', style: TextStyle(fontSize: 11)),
              Text('Level 3', style: TextStyle(fontSize: 11)),
              Text('Level 4', style: TextStyle(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: .52,
              minHeight: 8,
              backgroundColor: Colors.black12,
            ),
          ),
        ],
      );
}

class _AchievementRow extends StatelessWidget {
  const _AchievementRow({
    required this.label,
    required this.status,
    required this.statusIcon,
    this.isLocked = false,
  });

  final String label;
  final String status;
  final IconData statusIcon;
  final bool isLocked;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 7),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isLocked
              ? Colors.black.withValues(alpha: .05)
              : Theme.of(context).colorScheme.primary.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            Text(status,
                style: TextStyle(
                  color: isLocked
                      ? Colors.black45
                      : Theme.of(context).colorScheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(width: 4),
            Icon(statusIcon,
                size: 17,
                color: isLocked
                    ? Colors.black45
                    : Theme.of(context).colorScheme.primary),
          ],
        ),
      );
}
