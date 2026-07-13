import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'complete_header.dart';
import 'connect_later_button.dart';
import 'explore_button.dart';

class VerificationCompleteCard extends StatelessWidget {
  const VerificationCompleteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Logo
            SvgPicture.asset(
              'assets/icons/logo.svg',
              height: 88,
            ),

            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  CompleteHeader(),

                  SizedBox(height: 32),

                  ExploreButton(),

                  SizedBox(height: 14),

                  ConnectLaterButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}