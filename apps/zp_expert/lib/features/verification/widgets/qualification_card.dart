import 'package:flutter/material.dart';

import 'section_card.dart';
import 'upload_zone.dart';

class QualificationCard extends StatelessWidget {
  const QualificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "4. Qualification",
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xff111827),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Upload your degree or professional certificate.",
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: const Color(0xff6B7280),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          const UploadZone(
            icon: Icons.upload_file_rounded,
            title: "Upload Qualification",
            subtitle: "PDF, JPG or PNG • Max 10 MB",
          ),
        ],
      ),
    );
  }
}