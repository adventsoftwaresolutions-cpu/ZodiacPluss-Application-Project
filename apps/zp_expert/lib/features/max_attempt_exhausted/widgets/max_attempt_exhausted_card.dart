import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/widgets/top_scroll_fade.dart';
import 'contact_support_button.dart';
import 'logout_button.dart';
import 'max_attempt_header.dart';

class MaxAttemptExhaustedCard extends StatelessWidget {
  const MaxAttemptExhaustedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TopScrollFade(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// App Logo
              SvgPicture.asset(
                'assets/icons/logo.svg',
                height: 88,
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    MaxAttemptHeader(),
                    SizedBox(height: 30),
                    ContactSupportButton(),
                    SizedBox(height: 14),
                    LogoutButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
