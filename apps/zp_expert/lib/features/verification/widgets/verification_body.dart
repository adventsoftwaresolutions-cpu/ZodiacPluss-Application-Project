import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/app_routes.dart';
import '../../../shared/data/expert_profile.dart';
import '../../../shared/widgets/top_scroll_fade.dart';
import '../data/provider/verification_form_provider.dart';
import 'astrology_background_card.dart';
import 'basic_information_card.dart';
import 'education_experience_card.dart';
import 'professional_information_card.dart';
import 'profile_photo_card.dart';
import 'qualification_card.dart';
import 'specialization_card.dart';
import 'submit_button.dart';
import 'verification_header.dart';
import 'verification_logout_button.dart';
import 'verification_review_card.dart';
import 'verification_step_indicator.dart';
import 'verification_step_navigation.dart';
import 'work_preferences_card.dart';

class VerificationBody extends ConsumerStatefulWidget {
  const VerificationBody({super.key});

  @override
  ConsumerState<VerificationBody> createState() => _VerificationBodyState();
}

class _VerificationBodyState extends ConsumerState<VerificationBody>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _entranceController;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    final int initialStep = ref.read(verificationFormProvider).currentStep;
    _pageController = PageController(initialPage: initialStep);
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _fade = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, .04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));
    _entranceController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final VerificationFormState state = ref.watch(verificationFormProvider);
    final bool isPsychologist =
        state.form.profession == ExpertRole.psychologist;
    final bool isAstrologer = state.form.profession == ExpertRole.astrologer;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
                  child: Column(
                    children: <Widget>[
                      VerificationHeader(onSkip: _skipToHome),
                      const SizedBox(height: 18),
                      VerificationStepIndicator(
                        currentStep: state.currentStep,
                        onStepTap: _goToPreviousStep,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TopScrollFade(
                    notificationDepth: 1,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        const _StepScrollView(
                          key: ValueKey<String>('about-you'),
                          children: <Widget>[
                            ProfilePhotoCard(),
                            SizedBox(height: 16),
                            BasicInformationCard(),
                          ],
                        ),
                        const _StepScrollView(
                          key: ValueKey<String>('work-style'),
                          children: <Widget>[
                            ProfessionalInformationCard(),
                            SizedBox(height: 16),
                            WorkPreferencesCard(),
                          ],
                        ),
                        _StepScrollView(
                          key: const ValueKey<String>('expertise'),
                          children: <Widget>[
                            const VerificationEducationExperienceCard(),
                            if (isAstrologer) ...<Widget>[
                              const SizedBox(height: 16),
                              const AstrologyBackgroundCard(),
                            ],
                            const SizedBox(height: 16),
                            const SpecializationCard(),
                            if (isPsychologist) ...<Widget>[
                              const SizedBox(height: 16),
                              const QualificationCard(),
                            ],
                          ],
                        ),
                        _StepScrollView(
                          key: const ValueKey<String>('review'),
                          children: <Widget>[
                            VerificationReviewCard(onEditStep: _moveToStep),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      state.currentStep == 3
                          ? _FinalStepNavigation(onBack: _back)
                          : VerificationStepNavigation(
                              currentStep: state.currentStep,
                              onBack: _back,
                              onContinue: _continue,
                            ),
                      const SizedBox(height: 4),
                      const VerificationLogoutButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _continue() {
    final VerificationFormState state = ref.read(verificationFormProvider);
    final VerificationFormController controller =
        ref.read(verificationFormProvider.notifier);
    FocusScope.of(context).unfocus();
    if (!controller.validateStep(state.currentStep)) return;
    _moveToStep(state.currentStep + 1);
  }

  void _back() {
    final int currentStep = ref.read(verificationFormProvider).currentStep;
    if (currentStep == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    _moveToStep(currentStep - 1);
  }

  void _skipToHome() {
    FocusScope.of(context).unfocus();
    context.go(ExpertRoutes.home);
  }

  void _goToPreviousStep(int step) {
    final int currentStep = ref.read(verificationFormProvider).currentStep;
    if (step <= currentStep) _moveToStep(step);
  }

  void _moveToStep(int step) {
    FocusScope.of(context).unfocus();
    ref.read(verificationFormProvider.notifier).goToStep(step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }
}

class _StepScrollView extends StatelessWidget {
  const _StepScrollView({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        key: key,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
        child: Column(children: children),
      );
}

class _FinalStepNavigation extends StatelessWidget {
  const _FinalStepNavigation({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(flex: 2, child: SubmitButton()),
        ],
      );
}
