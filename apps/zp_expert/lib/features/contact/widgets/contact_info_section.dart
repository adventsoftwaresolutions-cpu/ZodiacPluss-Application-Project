import 'package:flutter/material.dart';

import '../data/contact_model.dart';
import 'contact_info_tile.dart';

class ContactInfoSection extends StatelessWidget {
  final List<ContactInfo> contactInfo;

  const ContactInfoSection({
    super.key,
    required this.contactInfo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Other Ways to Reach Us",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 10),

        ...contactInfo.map(
          (e) => ContactInfoTile(info: e),
        ),
      ],
    );
  }
}