import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_model.dart';
import '../data/auth_provider.dart';

class LoginButton extends ConsumerWidget {
  const LoginButton({
    required this.phoneController,
    required this.otpControllers,
    super.key,
  });

  final TextEditingController phoneController;
  final List<TextEditingController> otpControllers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: auth.isLoading
            ? null
            : () async {
                final notifier = ref.read(authProvider.notifier);

                if (auth.step == AuthStep.phone) {
                  await notifier.sendOtp(
                    phoneController.text.trim(),
                  );
                } else {
                  final otp = otpControllers
                      .map((controller) => controller.text)
                      .join();

                  await notifier.verifyOtp(otp);
                }
              },
        child: auth.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Text(
                auth.step == AuthStep.phone
                    ? 'Continue'
                    : 'Verify OTP',
              ),
      ),
    );
  }
}