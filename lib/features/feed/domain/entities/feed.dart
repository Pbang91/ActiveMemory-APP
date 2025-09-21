class Feed {
  final String name;
  final String slug;
  final String? description;
  final List<FeedMetric> metrics;
  final int commentCount;
  final int likeCount;

  const Feed({
    required this.name,
    required this.slug,
    this.description,
    required this.metrics,
    required this.commentCount,
    required this.likeCount,
  });
}

class FeedMetric {
  final String exerciseId;
  final String exerciseName;
  final int displayOrder;

  const FeedMetric({
    required this.exerciseId,
    required this.exerciseName,
    required this.displayOrder,
  });
}
