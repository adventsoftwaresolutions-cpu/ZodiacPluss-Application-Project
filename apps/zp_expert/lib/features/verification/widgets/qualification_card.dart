import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/provider/verification_form_provider.dart';
import 'section_card.dart';
import 'upload_zone.dart';

class QualificationCard extends ConsumerWidget {
  const QualificationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final String? fileName = ref.watch(
      verificationFormProvider.select(
        (VerificationFormState state) => state.form.qualificationFileName,
      ),
    );

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional Qualification',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xff111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Required for verification. Upload your degree or professional certificate.',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: const Color(0xff6B7280),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          UploadZone(
            icon: fileName == null
                ? Icons.upload_file_rounded
                : Icons.check_circle_outline_rounded,
            title: fileName ?? "Upload Qualification",
            subtitle: fileName == null
                ? "PDF, JPG or PNG • Max 10 MB"
                : 'Document attached · Tap to replace',
            onTap: () => _selectDocument(context, ref),
          ),
          if (fileName != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: ref
                    .read(verificationFormProvider.notifier)
                    .removeQualification,
                icon: const Icon(Icons.delete_outline, size: 17),
                label: const Text('Remove'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _selectDocument(BuildContext context, WidgetRef ref) async {
    final String? selection = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              title: Text('Choose qualification document'),
              subtitle: Text('Frontend showcase selection'),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: const Text('clinical-psychology-degree.pdf'),
              onTap: () =>
                  Navigator.of(context).pop('clinical-psychology-degree.pdf'),
            ),
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('professional-certificate.jpg'),
              onTap: () =>
                  Navigator.of(context).pop('professional-certificate.jpg'),
            ),
          ],
        ),
      ),
    );
    if (selection != null) {
      ref.read(verificationFormProvider.notifier).setQualification(selection);
    }
  }
}
