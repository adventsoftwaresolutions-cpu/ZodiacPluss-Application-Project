import 'package:flutter/material.dart';

import 'basic_information_card.dart';
import 'professional_information_card.dart';
import 'profile_photo_card.dart';
import 'qualification_card.dart';
import 'specialization_card.dart';
import 'submit_button.dart';
import 'verification_header.dart';

class VerificationBody extends StatefulWidget {
  const VerificationBody({super.key});

  @override
  State<VerificationBody> createState() => _VerificationBodyState();
}

class _VerificationBodyState extends State<VerificationBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fade;

  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween(
      begin: const Offset(0, .08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final bool desktop = width > 1100;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 900,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: desktop ? 40 : 18,
                vertical: 18,
              ),
              child: Column(
                children: [
                  const VerificationHeader(),

                  const SizedBox(height: 24),

                  const BasicInformationCard(),

                  const SizedBox(height: 18),

                  const ProfessionalInformationCard(),

                  const SizedBox(height: 18),

                  const SpecializationCard(),

                  const SizedBox(height: 18),

                  if (desktop)
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: QualificationCard(),
                        ),
                        SizedBox(width: 18),
                        Expanded(
                          child: ProfilePhotoCard(),
                        ),
                      ],
                    )
                  else ...[
                    const QualificationCard(),

                    const SizedBox(height: 18),

                    const ProfilePhotoCard(),
                  ],

                  const SizedBox(height: 28),

                  const SubmitButton(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}