import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../shared/widgets/shimmer_box.dart';

class ProfileLoadingSkeleton extends StatefulWidget {
  const ProfileLoadingSkeleton({super.key});

  @override
  State<ProfileLoadingSkeleton> createState() => _ProfileLoadingSkeletonState();
}

class _ProfileLoadingSkeletonState extends State<ProfileLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  static const int _entryCount = 5;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 920),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
        children: <Widget>[
          _AnimatedProfileSkeletonEntry(
            animation: _entryAnimation(0),
            child: const _ProfileHeaderSkeleton(),
          ),
          const SizedBox(height: 24),
          _AnimatedProfileSkeletonEntry(
            animation: _entryAnimation(1),
            child: const _CardSkeleton(height: 142),
          ),
          const SizedBox(height: 16),
          _AnimatedProfileSkeletonEntry(
            animation: _entryAnimation(2),
            child: const _CardSkeleton(height: 210),
          ),
          const SizedBox(height: 16),
          _AnimatedProfileSkeletonEntry(
            animation: _entryAnimation(3),
            child: const _CardSkeleton(height: 142),
          ),
          const SizedBox(height: 16),
          _AnimatedProfileSkeletonEntry(
            animation: _entryAnimation(4),
            child: const _CardSkeleton(height: 190),
          ),
        ],
      );

  Animation<double> _entryAnimation(int index) {
    const double segment = .34;
    final double start = index / (_entryCount - 1) * (1 - segment);
    final double end = math.min(1, start + segment);
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }
}

class _AnimatedProfileSkeletonEntry extends StatelessWidget {
  const _AnimatedProfileSkeletonEntry({
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, .08),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
}

class _ProfileHeaderSkeleton extends StatelessWidget {
  const _ProfileHeaderSkeleton();

  @override
  Widget build(BuildContext context) => const Row(
        children: <Widget>[
          ShimmerBox(width: 92, height: 92, borderRadius: 46),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ShimmerBox(width: 112, height: 24),
                SizedBox(height: 8),
                ShimmerBox(width: 84, height: 20),
                SizedBox(height: 8),
                ShimmerBox(width: 180, height: 14),
              ],
            ),
          ),
        ],
      );
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ShimmerBox(width: 164, height: 20),
            SizedBox(height: 16),
            ShimmerBox(width: double.infinity, height: 14),
            SizedBox(height: 9),
            ShimmerBox(width: 245, height: 14),
          ],
        ),
      );
}
