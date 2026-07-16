import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/verification_form_model.dart';
import '../data/provider/verification_form_provider.dart';
import 'section_card.dart';
import 'verification_input.dart';

class WorkPreferencesCard extends ConsumerWidget {
  const WorkPreferencesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VerificationFormModel form = ref.watch(
      verificationFormProvider.select(
        (VerificationFormState state) => state.form,
      ),
    );
    final VerificationFormController controller =
        ref.read(verificationFormProvider.notifier);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Your work rhythm',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          const Text(
            'A realistic schedule helps us send the right clients your way.',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 20),
          const Text(
            'Are you currently working on another platform?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          SegmentedButton<bool>(
            segments: const <ButtonSegment<bool>>[
              ButtonSegment<bool>(
                value: true,
                icon: Icon(Icons.check_rounded),
                label: Text('Yes'),
              ),
              ButtonSegment<bool>(
                value: false,
                icon: Icon(Icons.close_rounded),
                label: Text('No'),
              ),
            ],
            selected: form.worksOnOtherPlatform == null
                ? <bool>{}
                : <bool>{form.worksOnOtherPlatform!},
            emptySelectionAllowed: true,
            showSelectedIcon: false,
            onSelectionChanged: (Set<bool> values) {
              if (values.isNotEmpty) controller.setOtherPlatform(values.first);
            },
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            child: form.worksOnOtherPlatform == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: VerificationInput(
                      label: 'Platform name',
                      hint: 'e.g. Practo, AstroTalk',
                      icon: Icons.devices_other_outlined,
                      initialValue: form.otherPlatformName,
                      onChanged: controller.setOtherPlatformName,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 22),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Daily contribution',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Container(
                  key: ValueKey<int>(form.dailyContributionHours),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    form.dailyContributionHours == 0
                        ? 'Choose hours'
                        : '${form.dailyContributionHours} hours/day',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: form.dailyContributionHours.toDouble(),
            min: 0,
            max: 16,
            divisions: 16,
            label: '${form.dailyContributionHours} hours',
            onChanged: (double value) =>
                controller.setDailyContributionHours(value.round()),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('0h', style: TextStyle(fontSize: 11)),
              Text('8h', style: TextStyle(fontSize: 11)),
              Text('16h', style: TextStyle(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
