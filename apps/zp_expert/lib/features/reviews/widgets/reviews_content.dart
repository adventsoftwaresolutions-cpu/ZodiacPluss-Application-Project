import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/review_model.dart';
import '../data/provider/reviews_provider.dart';
import 'review_card.dart';
import 'review_card_skeleton.dart';
import 'reviews_overview_card.dart';

class ReviewsContent extends ConsumerWidget {
  const ReviewsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ReviewsOverview> reviews = ref.watch(reviewsProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      child: reviews.when(
        loading: () => const _ReviewsLoading(
          key: ValueKey<String>('reviews-loading'),
        ),
        error: (Object error, StackTrace stackTrace) => _ReviewsError(
          key: const ValueKey<String>('reviews-error'),
          onRetry: () => ref.invalidate(reviewsProvider),
        ),
        data: (ReviewsOverview overview) => _ReviewsList(
          key: const ValueKey<String>('reviews-data'),
          overview: overview,
          onRefresh: () async => ref.refresh(reviewsProvider.future),
          onReport: (ExpertReview review) =>
              _reportReview(context, ref, review),
        ),
      ),
    );
  }

  Future<void> _reportReview(
    BuildContext context,
    WidgetRef ref,
    ExpertReview review,
  ) async {
    final String? reason = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) => const _ReportReasonSheet(),
    );
    if (reason == null || !context.mounted) return;

    await ref.read(reviewsProvider.notifier).reportReview(
          reviewId: review.id,
          reason: reason,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review reported. Our team will take a look.'),
      ),
    );
  }
}

class _ReviewsList extends StatelessWidget {
  const _ReviewsList({
    required this.overview,
    required this.onRefresh,
    required this.onReport,
    super.key,
  });

  final ReviewsOverview overview;
  final Future<void> Function() onRefresh;
  final ValueChanged<ExpertReview> onReport;

  @override
  Widget build(BuildContext context) {
    if (overview.reviews.isEmpty) return const _ReviewsEmpty();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: 32),
        itemCount: overview.reviews.length + 2,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 14),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return ReviewsOverviewCard(
              averageRating: overview.averageRating,
              totalReviews: overview.totalReviews,
            );
          }
          if (index == 1) return const _ReviewsSectionHeader();

          final ExpertReview review = overview.reviews[index - 2];
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 260 + (index * 55)),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(begin: 0, end: 1),
            builder: (BuildContext context, double value, Widget? child) =>
                Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 12 * (1 - value)),
                child: child,
              ),
            ),
            child: ReviewCard(
              review: review,
              onReport: () => onReport(review),
            ),
          );
        },
      ),
    );
  }
}

class _ReviewsSectionHeader extends StatelessWidget {
  const _ReviewsSectionHeader();

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'Client reviews',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  'Latest first',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _ReportReasonSheet extends StatelessWidget {
  const _ReportReasonSheet();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.flag_outlined),
              title: Text('Report this review'),
              subtitle: Text('Select the reason that fits best.'),
            ),
            for (final String reason in <String>[
              'Spam or promotional content',
              'Abusive or inappropriate language',
              'Contains personal information',
              'Review is not about this session',
            ])
              ListTile(
                title: Text(reason),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).pop(reason),
              ),
            const SizedBox(height: 8),
          ],
        ),
      );
}

class _ReviewsLoading extends StatelessWidget {
  const _ReviewsLoading({super.key});

  @override
  Widget build(BuildContext context) => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 14),
        itemBuilder: (BuildContext context, int index) =>
            const ReviewCardSkeleton(),
      );
}

class _ReviewsError extends StatelessWidget {
  const _ReviewsError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.cloud_off_outlined, size: 42),
            const SizedBox(height: 10),
            const Text('Unable to load reviews.'),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      );
}

class _ReviewsEmpty extends StatelessWidget {
  const _ReviewsEmpty();

  @override
  Widget build(BuildContext context) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const <Widget>[
          SizedBox(height: 120),
          Icon(Icons.reviews_outlined, size: 48),
          SizedBox(height: 12),
          Center(child: Text('Your client reviews will appear here.')),
        ],
      );
}
