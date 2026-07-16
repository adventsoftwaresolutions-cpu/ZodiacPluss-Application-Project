import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/app_routes.dart';
import '../data/provider/verification_form_provider.dart';

class SubmitButton extends ConsumerWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VerificationFormState state = ref.watch(verificationFormProvider);

    return Column(
      children: <Widget>[
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          child: state.validationMessage == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    state.validationMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
        AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: state.isSubmitting ? .97 : 1,
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF18B6A8),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed:
                  state.isSubmitting ? null : () => _submit(context, ref),
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Submit Verification',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    FocusScope.of(context).unfocus();
    final bool submitted =
        await ref.read(verificationFormProvider.notifier).submit();
    if (!context.mounted || !submitted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification submitted successfully.')),
    );
    context.go(ExpertRoutes.home);
  }
}
