import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/constants/app_assets.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import 'ticket_styles.dart';

class TicketAttachmentArea extends StatelessWidget {
  const TicketAttachmentArea({
    required this.attachments,
    required this.onAddAttachment,
    required this.onRemoveAttachment,
    super.key,
  });

  final List<String> attachments;
  final ValueChanged<String> onAddAttachment;
  final ValueChanged<String> onRemoveAttachment;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () async {
          const List<String> files = <String>[
            'screenshot.png',
            'session-details.pdf',
            'support-document.docx',
          ];
          final String? selectedFile = await showModalBottomSheet<String>(
            context: context,
            showDragHandle: true,
            builder: (BuildContext context) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: files
                    .map((String file) => ListTile(
                          leading: const Icon(Icons.attach_file_rounded),
                          title: Text(file),
                          onTap: () => Navigator.pop(context, file),
                        ))
                    .toList(),
              ),
            ),
          );
          if (selectedFile != null) onAddAttachment(selectedFile);
        },
        child: CustomPaint(
          foregroundPainter: const _DashedRoundedBorderPainter(),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 84),
            padding: const EdgeInsets.all(12),
            child: attachments.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(AppAssets.uploadIcon,
                          width: 30, height: 30),
                      const SizedBox(height: 4),
                      const Text('Tap to upload or Drag and Drop',
                          style: TicketStyles.uploadTitle),
                      const SizedBox(height: 3),
                      const Text('Images, PDF, or documents (Max 10MB)',
                          style: TicketStyles.uploadSubtitle),
                    ],
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: attachments
                        .map((String file) => InputChip(
                              label: Text(file),
                              onDeleted: () => onRemoveAttachment(file),
                              avatar: const Icon(
                                  Icons.insert_drive_file_outlined,
                                  size: 18),
                            ))
                        .toList(),
                  ),
          ),
        ),
      );
}

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 1.25
      ..style = PaintingStyle.stroke;
    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(AppRadius.md),
      ));
    for (final PathMetric metric in path.computeMetrics()) {
      for (double distance = 0; distance < metric.length; distance += 8) {
        canvas.drawPath(metric.extractPath(distance, distance + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedBorderPainter oldDelegate) =>
      false;
}
