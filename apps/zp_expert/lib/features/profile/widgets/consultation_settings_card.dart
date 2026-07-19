import 'package:flutter/material.dart';

import '../../../shared/data/expert_profile.dart';
import 'profile_section_card.dart';

class ConsultationSettingsCard extends StatelessWidget {
  const ConsultationSettingsCard({
    required this.rates,
    required this.onEdit,
    super.key,
  });

  final List<ConsultationRate> rates;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) => ProfileSectionCard(
        child: Column(
          children: <Widget>[
            ProfileSectionTitle(
              icon: Icons.settings_outlined,
              title: 'Consultation Settings',
              action: TextButton(
                onPressed: onEdit,
                child: const Text('Edit'),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: rates
                  .map((ConsultationRate rate) => _RateCard(rate: rate))
                  .toList(),
            ),
          ],
        ),
      );
}

class _RateCard extends StatelessWidget {
  const _RateCard({required this.rate});

  final ConsultationRate rate;

  @override
  Widget build(BuildContext context) => Container(
        width: 118,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .11),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Icon(_iconFor(rate.type),
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 5),
            Text(rate.type.label,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center),
            const SizedBox(height: 2),
            Text('₹ ${rate.ratePerMinute} / min',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                )),
          ],
        ),
      );

  IconData _iconFor(ConsultationType type) => switch (type) {
        ConsultationType.video => Icons.videocam_outlined,
        ConsultationType.voice => Icons.phone_outlined,
        ConsultationType.chat => Icons.chat_bubble_outline_rounded,
      };
}
