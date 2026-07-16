class ExpertReview {
  const ExpertReview({
    required this.id,
    required this.clientName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.isReported,
  });

  final String id;
  final String clientName;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final bool isReported;

  ExpertReview copyWith({bool? isReported}) => ExpertReview(
        id: id,
        clientName: clientName,
        rating: rating,
        comment: comment,
        createdAt: createdAt,
        isReported: isReported ?? this.isReported,
      );

  factory ExpertReview.fromJson(Map<String, dynamic> json) => ExpertReview(
        id: json['id'] as String,
        clientName: json['clientName'] as String,
        rating: json['rating'] as int,
        comment: json['comment'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        isReported: json['isReported'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'clientName': clientName,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
        'isReported': isReported,
      };
}

class ReviewsOverview {
  const ReviewsOverview({
    required this.averageRating,
    required this.totalReviews,
    required this.reviews,
  });

  final double averageRating;
  final int totalReviews;
  final List<ExpertReview> reviews;

  ReviewsOverview copyWith({List<ExpertReview>? reviews}) => ReviewsOverview(
        averageRating: averageRating,
        totalReviews: totalReviews,
        reviews: reviews ?? this.reviews,
      );

  ReviewsOverview latestFirst() {
    final List<ExpertReview> sorted = List<ExpertReview>.of(reviews)
      ..sort((ExpertReview a, ExpertReview b) =>
          b.createdAt.compareTo(a.createdAt));
    return copyWith(reviews: sorted);
  }

  factory ReviewsOverview.fromJson(Map<String, dynamic> json) =>
      ReviewsOverview(
        averageRating: (json['averageRating'] as num).toDouble(),
        totalReviews: json['totalReviews'] as int,
        reviews: (json['reviews'] as List<dynamic>)
            .map((dynamic item) =>
                ExpertReview.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'averageRating': averageRating,
        'totalReviews': totalReviews,
        'reviews': reviews.map((ExpertReview item) => item.toJson()).toList(),
      };
}
