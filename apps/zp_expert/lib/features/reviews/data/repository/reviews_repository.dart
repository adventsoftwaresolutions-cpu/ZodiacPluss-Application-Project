import '../models/review_model.dart';

abstract class ReviewsRepository {
  Future<ReviewsOverview> fetchReviews();

  Future<void> reportReview({required String reviewId, required String reason});
}

class StubReviewsRepository implements ReviewsRepository {
  final Set<String> _reportedReviewIds = <String>{};

  @override
  Future<ReviewsOverview> fetchReviews() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final DateTime now = DateTime.now();
    return ReviewsOverview(
      averageRating: 4.8,
      totalReviews: 128,
      reviews: <ExpertReview>[
        ExpertReview(
          id: 'review-4',
          clientName: 'Rohan Mehta',
          rating: 4,
          comment:
              'The session gave me a practical way to think through my concerns. Very patient and thoughtful.',
          createdAt: now.subtract(const Duration(days: 6, hours: 2)),
          isReported: _reportedReviewIds.contains('review-4'),
        ),
        ExpertReview(
          id: 'review-1',
          clientName: 'Ananya Singh',
          rating: 5,
          comment:
              'I felt heard from the very beginning. The guidance was warm, clear and genuinely useful.',
          createdAt: now.subtract(const Duration(hours: 2)),
          isReported: _reportedReviewIds.contains('review-1'),
        ),
        ExpertReview(
          id: 'review-3',
          clientName: 'Meera Iyer',
          rating: 5,
          comment:
              'A calm and reassuring conversation. I left the session feeling much more confident.',
          createdAt: now.subtract(const Duration(days: 3, hours: 4)),
          isReported: _reportedReviewIds.contains('review-3'),
        ),
        ExpertReview(
          id: 'review-2',
          clientName: 'Kabir Shah',
          rating: 5,
          comment:
              'Excellent listener and very professional. The suggestions were easy to understand and follow.',
          createdAt: now.subtract(const Duration(days: 1, hours: 3)),
          isReported: _reportedReviewIds.contains('review-2'),
        ),
      ],
    );
  }

  @override
  Future<void> reportReview({
    required String reviewId,
    required String reason,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _reportedReviewIds.add(reviewId);
  }
}
