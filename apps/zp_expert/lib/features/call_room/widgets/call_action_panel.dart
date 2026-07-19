import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../themes/app_radius.dart';

class CallActionPanel extends StatelessWidget {
  const CallActionPanel({
    required this.ended,
    required this.controls,
    required this.onLeave,
    super.key,
  });

  final bool ended;
  final Widget controls;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 460),
        curve: Curves.easeOutCubic,
        tween: Tween<double>(end: ended ? .78 : 1),
        builder: (BuildContext context, double widthFactor, Widget? child) =>
            FractionallySizedBox(widthFactor: widthFactor, child: child),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl + 4),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 460),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.fromLTRB(
                ended ? 14 : 12,
                ended ? 12 : 14,
                ended ? 14 : 12,
                ended ? 12 : 13,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .scrim
                    .withValues(alpha: ended ? .66 : .5),
                borderRadius: BorderRadius.circular(AppRadius.xl + 4),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimary
                      .withValues(alpha: ended ? .28 : .14),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .2),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 460),
                curve: Curves.easeOutCubic,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (Widget child, Animation<double> value) =>
                      FadeTransition(
                    opacity: value,
                    child: SizeTransition(
                      sizeFactor: value,
                      alignment: Alignment.topCenter,
                      child: ScaleTransition(scale: value, child: child),
                    ),
                  ),
                  child: ended
                      ? _BackToAppAction(onLeave: onLeave)
                      : KeyedSubtree(
                          key: const ValueKey<String>('active-call-controls'),
                          child: controls,
                        ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _BackToAppAction extends StatelessWidget {
  const _BackToAppAction({required this.onLeave});

  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) => Row(
        key: const ValueKey<String>('ended-call-action'),
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withValues(alpha: .18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.call_end_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.icon(
              key: const ValueKey<String>('leave-ended-call-button'),
              onPressed: onLeave,
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Back to app'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                minimumSize: const Size(0, 44),
              ),
            ),
          ),
        ],
      );
}
