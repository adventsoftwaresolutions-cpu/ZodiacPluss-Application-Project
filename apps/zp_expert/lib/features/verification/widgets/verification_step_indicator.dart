import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../shared/constants/app_assets.dart';

class VerificationStepIndicator extends StatefulWidget {
  const VerificationStepIndicator({
    required this.currentStep,
    required this.onStepTap,
    super.key,
  });

  static const List<String> labels = <String>[
    'About you',
    'Work style',
    'Expertise',
    'Review',
  ];

  final int currentStep;
  final ValueChanged<int> onStepTap;

  @override
  State<VerificationStepIndicator> createState() =>
      _VerificationStepIndicatorState();
}

class _VerificationStepIndicatorState extends State<VerificationStepIndicator>
    with SingleTickerProviderStateMixin {
  static const Duration _transitionDuration = Duration(milliseconds: 520);
  static const Color _sourceCompletedColor = Color(0xFF333C45);
  static const Color _sourcePendingColor = Color(0xFF5359FD);

  late final AnimationController _controller;
  late final LottieDelegates _colorDelegates;
  bool _isLoaded = false;

  double get _targetProgress =>
      widget.currentStep / VerificationStepIndicator.labels.length;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _colorDelegates = LottieDelegates(
      values: <ValueDelegate<dynamic>>[
        ValueDelegate.color(
          <String>['**'],
          callback: (frameInfo) =>
              _reversedStepColor(frameInfo.startValue, frameInfo.endValue),
        ),
        ValueDelegate.strokeColor(
          <String>['**'],
          callback: (frameInfo) =>
              _reversedStepColor(frameInfo.startValue, frameInfo.endValue),
        ),
      ],
    );
  }

  Color _reversedStepColor(Color? startValue, Color? endValue) {
    final Color original = startValue ?? endValue ?? Colors.transparent;
    if (original == _sourceCompletedColor) return _sourcePendingColor;
    if (original == _sourcePendingColor) return _sourceCompletedColor;
    return original;
  }

  @override
  void didUpdateWidget(covariant VerificationStepIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isLoaded && oldWidget.currentStep != widget.currentStep) {
      _moveToCurrentStep();
    }
  }

  void _onLoaded(LottieComposition composition) {
    _controller.duration = composition.duration;
    _controller.value = _targetProgress;
    _isLoaded = true;
  }

  void _moveToCurrentStep() {
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = _targetProgress;
      return;
    }
    _controller.animateTo(
      _targetProgress,
      duration: _transitionDuration,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Application progress',
        value:
            'Step ${widget.currentStep + 1} of ${VerificationStepIndicator.labels.length}',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Step ${widget.currentStep + 1} of ${VerificationStepIndicator.labels.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: .62),
                      ),
                ),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Text(
                    VerificationStepIndicator.labels[widget.currentStep],
                    key: ValueKey<int>(widget.currentStep),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Lottie.asset(
                    AppAssets.verificationStepsAnimation,
                    key: const ValueKey<String>('verification-step-lottie'),
                    controller: _controller,
                    delegates: _colorDelegates,
                    animate: false,
                    repeat: false,
                    fit: BoxFit.contain,
                    onLoaded: _onLoaded,
                  ),
                  _StepTapTargets(
                    currentStep: widget.currentStep,
                    onStepTap: widget.onStepTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _StepTapTargets extends StatelessWidget {
  const _StepTapTargets({
    required this.currentStep,
    required this.onStepTap,
  });

  final int currentStep;
  final ValueChanged<int> onStepTap;

  @override
  Widget build(BuildContext context) => Row(
        children: List<Widget>.generate(
          VerificationStepIndicator.labels.length,
          (int step) => Expanded(
            child: Semantics(
              button: true,
              label: VerificationStepIndicator.labels[step],
              child: SizedBox.expand(
                key: ValueKey<String>('verification-step-target-$step'),
                child: InkWell(
                  onTap: step < currentStep ? () => onStepTap(step) : null,
                ),
              ),
            ),
          ),
        ),
      );
}
