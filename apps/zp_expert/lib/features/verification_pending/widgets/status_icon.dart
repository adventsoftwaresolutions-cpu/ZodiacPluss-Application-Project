import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatusIcon extends StatelessWidget {
  const StatusIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icons/verification_pending.svg",
      height: 72,
      width: 72,
    );
  }
}