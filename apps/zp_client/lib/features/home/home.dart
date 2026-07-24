import 'package:flutter/material.dart';
import '../../core/themes/app_colors.dart';
import 'widgets/mood_tracker_widget.dart'; // adjust path to your actual home widgets folder

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            AppColors.primaryVariant,
          ],
        ),
      ),
      child: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MoodTrackerWidget(),
              SizedBox(height: 24),
              Text(
                "What would you like today?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
