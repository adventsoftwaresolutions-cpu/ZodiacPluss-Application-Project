import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/app_routes.dart';
import 'auth_glass_panel.dart';
import 'login_logo.dart';
import 'otp_box.dart';
import 'primary_button.dart';

enum AuthStep {
  phone,
  otp,
}

class AuthBody extends StatefulWidget {
  const AuthBody({super.key});

  @override
  State<AuthBody> createState() => _AuthBodyState();
}

class _AuthBodyState extends State<AuthBody> with TickerProviderStateMixin {
  final phoneController = TextEditingController();

  final phoneFocus = FocusNode();

  final otpControllers = List.generate(4, (_) => TextEditingController());

  final otpFocus = List.generate(4, (_) => FocusNode());

  AuthStep step = AuthStep.phone;

  bool loading = false;

  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();

    phoneController.dispose();
    phoneFocus.dispose();

    for (final c in otpControllers) {
      c.dispose();
    }

    for (final f in otpFocus) {
      f.dispose();
    }

    super.dispose();
  }

  Future<void> continuePressed() async {
    if (phoneController.text.length != 10) return;

    FocusScope.of(context).unfocus();

    setState(() {
      loading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 900),
    );

    setState(() {
      loading = false;
      step = AuthStep.otp;
    });

    controller.forward(from: 0);

    Future.delayed(
      const Duration(milliseconds: 250),
      () {
        otpFocus.first.requestFocus();
      },
    );
  }

  Future<void> verifyPressed() async {
    setState(() {
      loading = true;
    });

    await Future.delayed(
      const Duration(seconds: 1),
    );

    setState(() {
      loading = false;
    });
    if (mounted) context.go(ExpertRoutes.verification);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bool isCompact = MediaQuery.sizeOf(context).width < 360;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 16 : 24,
          vertical: 20,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 420,
          ),
          child: AuthGlassPanel(
            child: Column(
              children: [
                const SizedBox(height: 8),
                const LoginLogo(),
                const SizedBox(height: 28),
                AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 450,
                  ),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  child: step == AuthStep.phone
                      ? _buildPhone(theme, colors)
                      : _buildOtp(theme, colors),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  loading: loading,
                  text: step == AuthStep.phone ? "Continue" : "Verify OTP",
                  onPressed:
                      step == AuthStep.phone ? continuePressed : verifyPressed,
                ),
                const SizedBox(height: 18),
                Text(
                  "Need help? Contact Support",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: .72),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhone(
    ThemeData theme,
    ColorScheme colors,
  ) {
    return Column(
      key: const ValueKey("phone"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Welcome to Our Expert App !",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            "Login with your phone number to continue\nyour Expert journey",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withValues(alpha: .68),
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "Phone Number",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: .94),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: colors.onSurface.withValues(alpha: .14),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Text(
                "🇮🇳",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              const Text(
                "+91",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 1,
                height: 24,
                color: colors.onSurface.withValues(alpha: .14),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: phoneController,
                  focusNode: phoneFocus,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    hintText: "Enter your phone number",
                    hintStyle: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.lock_outline,
              size: 16,
              color: colors.primary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                "We'll send you a secure OTP to verify your number",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: .76),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtp(
    ThemeData theme,
    ColorScheme colors,
  ) {
    final double boxGap = MediaQuery.sizeOf(context).width < 360 ? 6 : 10;
    return Column(
      key: const ValueKey("otp"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Verify OTP",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            "Enter the OTP sent to your\nregistered mobile number",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withValues(alpha: .68),
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: List.generate(
            4,
            (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == 3 ? 0 : boxGap,
                ),
                child: OtpBox(
                  controller: otpControllers[index],
                  focusNode: otpFocus[index],
                  onDigitEntered: index == otpControllers.length - 1
                      ? null
                      : () => otpFocus[index + 1].requestFocus(),
                  onBackspaceWhenEmpty: index == 0
                      ? null
                      : () => _focusAndSelectOtpBox(index - 1),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Center(
          child: TextButton(
            onPressed: () {},
            child: Text(
              "Resend OTP",
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _focusAndSelectOtpBox(int index) {
    final TextEditingController controller = otpControllers[index];
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
    otpFocus[index].requestFocus();
  }
}
