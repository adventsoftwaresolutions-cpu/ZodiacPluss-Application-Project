import 'package:flutter/material.dart';
import 'package:zp_core/zp_core.dart';

import '../../shared/widgets/gradient_page.dart';
import 'widgets/kundali_header.dart';

class KundaliPage extends StatelessWidget {
  const KundaliPage({this.birthData, super.key});

  final KundaliBirthData? birthData;

  static final KundaliBirthData _previewBirthData = KundaliBirthData(
    birthDateTimeUtc: DateTime.utc(1990, 5, 12, 8, 30),
    latitude: 28.6139,
    longitude: 77.2090,
    timeZoneId: 'Asia/Kolkata',
    placeName: 'New Delhi',
  );

  @override
  Widget build(BuildContext context) {
    return GradientPage(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: KundaliHeader(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: KundaliView(
                birthData: birthData ?? _previewBirthData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
