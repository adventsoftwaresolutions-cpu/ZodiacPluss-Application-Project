import 'package:flutter/material.dart';

import 'section_card.dart';
import 'verification_dropdown.dart';

class ProfessionalInformationCard extends StatelessWidget {
  const ProfessionalInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final bool desktop = width > 850;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "2. Professional Information",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: const Color(0xff111827),
                ),
          ),

          const SizedBox(height: 6),

          Text(
            "Tell us about your professional background.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  color: const Color(0xff6B7280),
                  height: 1.6,
                ),
          ),

          const SizedBox(height: 22),

          if (desktop) ...[
            Row(
              children: [
                Expanded(child: _gender()),
                const SizedBox(width: 18),
                Expanded(child: _profession()),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(child: _experience()),
                const SizedBox(width: 18),
                Expanded(child: _availability()),
              ],
            ),
          ] else ...[
            _gender(),

            const SizedBox(height: 18),

            _profession(),

            const SizedBox(height: 18),

            _experience(),

            const SizedBox(height: 18),

            _availability(),
          ],
        ],
      ),
    );
  }

  Widget _gender() {
    return VerificationDropdown<String>(
      label: "Gender",
      hint: "Select Gender",
      icon: Icons.person_outline_rounded,
      items: const [
        DropdownMenuItem(
          value: "Male",
          child: Text("Male"),
        ),
        DropdownMenuItem(
          value: "Female",
          child: Text("Female"),
        ),
        DropdownMenuItem(
          value: "Other",
          child: Text("Other"),
        ),
      ],
    );
  }

  Widget _profession() {
    return VerificationDropdown<String>(
      label: "Profession",
      hint: "Select Profession",
      icon: Icons.work_outline_rounded,
      items: const [
        DropdownMenuItem(
          value: "Psychologist",
          child: Text("Psychologist"),
        ),
        DropdownMenuItem(
          value: "Counsellor",
          child: Text("Counsellor"),
        ),
        DropdownMenuItem(
          value: "Therapist",
          child: Text("Therapist"),
        ),
      ],
    );
  }

  Widget _experience() {
    return VerificationDropdown<String>(
      label: "Experience",
      hint: "Years of Experience",
      icon: Icons.timeline_rounded,
      items: const [
        DropdownMenuItem(
          value: "1-3",
          child: Text("1-3 Years"),
        ),
        DropdownMenuItem(
          value: "3-5",
          child: Text("3-5 Years"),
        ),
        DropdownMenuItem(
          value: "5+",
          child: Text("5+ Years"),
        ),
      ],
    );
  }

  Widget _availability() {
    return VerificationDropdown<String>(
      label: "Availability",
      hint: "Select Availability",
      icon: Icons.schedule_rounded,
      items: const [
        DropdownMenuItem(
          value: "Full Time",
          child: Text("Full Time"),
        ),
        DropdownMenuItem(
          value: "Part Time",
          child: Text("Part Time"),
        ),
      ],
    );
  }
}