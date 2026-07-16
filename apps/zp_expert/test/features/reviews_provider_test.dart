import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zp_expert/features/reviews/data/models/review_model.dart';
import 'package:zp_expert/features/reviews/data/provider/reviews_provider.dart';
import 'package:zp_expert/features/reviews/data/repository/reviews_repository.dart';

void main() {
  test('reviews are always exposed latest first', () async {
    final _RecordingReviewsRepository repository =
        _RecordingReviewsRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        reviewsRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final ReviewsOverview overview =
        await container.read(reviewsProvider.future);

    expect(
      overview.reviews.map((ExpertReview review) => review.id),
      <String>['latest', 'older'],
    );
  });

  test('reporting is delegated and reflected in review state', () async {
    final _RecordingReviewsRepository repository =
        _RecordingReviewsRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        reviewsRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await container.read(reviewsProvider.future);

    await container.read(reviewsProvider.notifier).reportReview(
          reviewId: 'latest',
          reason: 'Spam',
        );

    expect(repository.reportedReviewId, 'latest');
    expect(repository.reportReason, 'Spam');
    expect(
      container.read(reviewsProvider).requireValue.reviews.first.isReported,
      isTrue,
    );
  });
}

class _RecordingReviewsRepository implements ReviewsRepository {
  String? reportedReviewId;
  String? reportReason;

  @override
  Future<ReviewsOverview> fetchReviews() async => ReviewsOverview(
        averageRating: 4.5,
        totalReviews: 2,
        reviews: <ExpertReview>[
          ExpertReview(
            id: 'older',
            clientName: 'Older Client',
            rating: 4,
            comment: 'Older review',
            createdAt: DateTime(2026, 1),
            isReported: false,
          ),
          ExpertReview(
            id: 'latest',
            clientName: 'Latest Client',
            rating: 5,
            comment: 'Latest review',
            createdAt: DateTime(2026, 2),
            isReported: false,
          ),
        ],
      );

  @override
  Future<void> reportReview({
    required String reviewId,
    required String reason,
  }) async {
    reportedReviewId = reviewId;
    reportReason = reason;
  }
}
