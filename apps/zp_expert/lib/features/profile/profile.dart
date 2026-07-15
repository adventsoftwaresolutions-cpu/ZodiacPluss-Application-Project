import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import 'widgets/profile_content.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientPage(
      child: SafeArea(
        bottom: false,
        child: ProfileContent(),
      ),
    );
  }
}
