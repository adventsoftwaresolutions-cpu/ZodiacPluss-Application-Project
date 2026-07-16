import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../shared/constants/app_assets.dart';

Future<void> showChangeRequestDialog(
  BuildContext context, {
  required String section,
}) {
  return showDialog<void>(
    context: context,
    useRootNavigator: true,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 120,
            height: 120,
            child: Lottie.asset(
              AppAssets.paperPlaneAnimation,
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Change request raised',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your $section update was sent to the admin for review. It will appear on your profile after approval.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ),
        ],
      ),
    ),
  );
}
