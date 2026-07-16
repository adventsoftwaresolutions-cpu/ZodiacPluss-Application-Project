import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/provider/verification_form_provider.dart';

class VerificationStepNavigation extends ConsumerWidget {
  const VerificationStepNavigation({
    required this.currentStep,
    required this.onBack,
    required this.onContinue,
    super.key,
  });

  final int currentStep;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? message = ref.watch(
      verificationFormProvider.select(
        (VerificationFormState state) => state.validationMessage,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: message == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
        Row(
          children: <Widget>[
            if (currentStep > 0) ...<Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: currentStep > 0 ? 1 : 2,
              child: FilledButton.icon(
                onPressed: onContinue,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Continue'),
                iconAlignment: IconAlignment.end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
