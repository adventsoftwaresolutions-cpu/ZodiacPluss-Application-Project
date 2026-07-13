import 'package:flutter/material.dart';

import 'section_card.dart';
import 'verification_input.dart';

class BasicInformationCard extends StatelessWidget {
  const BasicInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final bool desktop = width > 850;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "1. Basic Information",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: const Color(0xff111827),
                ),
          ),

          const SizedBox(height: 6),

          Text(
            "Please provide your personal information as it appears on your official documents.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xff6B7280),
                  fontSize: 13,
                  height: 1.6,
                ),
          ),

          const SizedBox(height: 22),

          if (desktop)
            Row(
              children: const [
                Expanded(
                  child: VerificationInput(
                    label: "Full Name",
                    hint: "Enter full name",
                    icon: Icons.person_outline_rounded,
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: VerificationInput(
                    label: "Email Address",
                    hint: "Enter email address",
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.mail_outline_rounded,
                  ),
                ),
              ],
            )
          else ...[
            const VerificationInput(
              label: "Full Name",
              hint: "Enter full name",
              icon: Icons.person_outline_rounded,
            ),

            const SizedBox(height: 18),

            const VerificationInput(
              label: "Email Address",
              hint: "Enter email address",
              keyboardType: TextInputType.emailAddress,
              icon: Icons.mail_outline_rounded,
            ),
          ],

          const SizedBox(height: 18),

          const VerificationInput(
            label: "Address",
            hint: "Enter complete address",
            icon: Icons.location_on_outlined,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}