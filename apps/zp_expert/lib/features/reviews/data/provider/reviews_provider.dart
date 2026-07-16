import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/review_model.dart';
import '../repository/reviews_repository.dart';

final Provider<ReviewsRepository> reviewsRepositoryProvider =
    Provider<ReviewsRepository>((Ref ref) => StubReviewsRepository());

final AsyncNotifierProvider<ReviewsController, ReviewsOverview>
    reviewsProvider = AsyncNotifierProvider<ReviewsController, ReviewsOverview>(
  ReviewsController.new,
);

class ReviewsController extends AsyncNotifier<ReviewsOverview> {
  @override
  Future<ReviewsOverview> build() async {
    final ReviewsOverview overview =
        await ref.read(reviewsRepositoryProvider).fetchReviews();
    return overview.latestFirst();
  }

  Future<void> reportReview({
    required String reviewId,
    required String reason,
  }) async {
    final ReviewsOverview? current = state.asData?.value;
    if (current == null) return;

    await ref.read(reviewsRepositoryProvider).reportReview(
          reviewId: reviewId,
          reason: reason,
        );
    state = AsyncData<ReviewsOverview>(
      current.copyWith(
        reviews: current.reviews
            .map((ExpertReview review) => review.id == reviewId
                ? review.copyWith(isReported: true)
                : review)
            .toList(),
      ),
    );
  }
}
