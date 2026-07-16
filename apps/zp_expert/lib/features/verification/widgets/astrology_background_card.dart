import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/provider/verification_form_provider.dart';
import 'section_card.dart';
import 'verification_input.dart';

class AstrologyBackgroundCard extends ConsumerWidget {
  const AstrologyBackgroundCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String initialValue = ref.watch(
      verificationFormProvider.select(
        (VerificationFormState state) => state.form.astrologyLearningSource,
      ),
    );
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: .12),
                child: Icon(
                  Icons.auto_awesome_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your astrology journey',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Every astrologer has a story—tell us where you learned your craft.',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 18),
          VerificationInput(
            label: 'Where did you learn astrology?',
            hint: 'Guru, institute, family tradition, or self-study',
            icon: Icons.menu_book_outlined,
            maxLines: 2,
            initialValue: initialValue,
            onChanged: ref
                .read(verificationFormProvider.notifier)
                .setAstrologyLearningSource,
          ),
        ],
      ),
    );
  }
}
