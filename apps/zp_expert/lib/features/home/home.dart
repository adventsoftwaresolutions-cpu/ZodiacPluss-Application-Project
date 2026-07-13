// home.dart
import 'package:flutter/material.dart';
import '../../shared/widgets/gradient_page.dart';
import 'widgets/profile_greeting_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientPage(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ProfileGreetingHeader(
            name: 'Shreya',
            role: 'Psychologist',
            avatarUrl: 'assets/images/dp.jpg',
            isVerified: true,
            isAvailable: true,
            onNotificationTap: () {},
            onChatTap: () {},
          ),
        ),
      ),
    );
  }
}