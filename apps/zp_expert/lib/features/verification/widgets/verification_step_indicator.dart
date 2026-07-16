import 'package:flutter/material.dart';

class VerificationStepIndicator extends StatelessWidget {
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
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 500) {
            return _CompactProgress(
              currentStep: currentStep,
              onStepTap: onStepTap,
            );
          }
          return Row(
            children: List<Widget>.generate(labels.length * 2 - 1, (int index) {
              if (index.isOdd) {
                final int beforeStep = index ~/ 2;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    height: 2,
                    color: beforeStep < currentStep
                        ? Theme.of(context).colorScheme.primary
                        : const Color(0xFFD9E0E4),
                  ),
                );
              }
              final int step = index ~/ 2;
              return _StepNode(
                step: step,
                label: labels[step],
                currentStep: currentStep,
                onTap: () => onStepTap(step),
              );
            }),
          );
        },
      );
}

class _CompactProgress extends StatelessWidget {
  const _CompactProgress({
    required this.currentStep,
    required this.onStepTap,
  });

  final int currentStep;
  final ValueChanged<int> onStepTap;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Step ${currentStep + 1} of ${VerificationStepIndicator.labels.length}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              const Spacer(),
              Text(
                VerificationStepIndicator.labels[currentStep],
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: List<Widget>.generate(
              VerificationStepIndicator.labels.length,
              (int step) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: step == VerificationStepIndicator.labels.length - 1
                        ? 0
                        : 6,
                  ),
                  child: InkWell(
                    onTap: () => onStepTap(step),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 5,
                      decoration: BoxDecoration(
                        color: step <= currentStep
                            ? Theme.of(context).colorScheme.primary
                            : const Color(0xFFD9E0E4),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}

class _StepNode extends StatelessWidget {
  const _StepNode({
    required this.step,
    required this.label,
    required this.currentStep,
    required this.onTap,
  });

  final int step;
  final String label;
  final int currentStep;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool active = step <= currentStep;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Column(
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: active
                    ? Theme.of(context).colorScheme.primary
                    : const Color(0xFFE6ECEF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: step < currentStep
                    ? const Icon(Icons.check_rounded,
                        size: 17, color: Colors.white)
                    : Text(
                        '${step + 1}',
                        style: TextStyle(
                          color:
                              active ? Colors.white : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
