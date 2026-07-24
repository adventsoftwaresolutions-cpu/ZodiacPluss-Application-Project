import 'package:flutter/material.dart';
import 'package:zp_core/zp_core.dart';

/// Client-owned page chrome around the shared Kundali experience.
class KundaliPage extends StatelessWidget {
  const KundaliPage({
    required this.birthData,
    super.key,
  });

  final KundaliBirthData birthData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Kundali')),
      body: Theme(
        data: theme.copyWith(
          extensions: <ThemeExtension<dynamic>>[
            KundaliThemeData(
              contentBackgroundColor: theme.scaffoldBackgroundColor,
              successColor: theme.colorScheme.primary,
            ),
          ],
        ),
        child: KundaliView(
          birthData: birthData,
          topBorderRadius: 0,
        ),
      ),
    );
  }
}
