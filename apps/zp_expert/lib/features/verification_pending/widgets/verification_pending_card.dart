import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/widgets/top_scroll_fade.dart';
import 'logout_button.dart';
import 'next_steps_card.dart';
import 'pending_header.dart';

class VerificationPendingCard extends StatelessWidget {
  const VerificationPendingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TopScrollFade(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              /// App Logo
              SvgPicture.asset(
                'assets/icons/logo.svg',
                height: 72,
              ),

              const SizedBox(height: 24),

              /// Main Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  24,
                  32, // Increased top padding
                  24,
                  24,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    PendingHeader(),
                    SizedBox(height: 20),
                    NextStepsCard(),
                    SizedBox(height: 24),
                    LogoutButton(),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
