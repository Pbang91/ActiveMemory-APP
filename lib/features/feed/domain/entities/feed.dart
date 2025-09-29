class Feed {
  final String slug;
  final Author author;
  final String? description;
  final List<FeedMetric> metrics;
  final List<FeedComment> comments;
  final List<FeedLiker> likers;
  final DateTime createdAt;
  final String? imageUrl;
  final bool likedFeed;

  const Feed({
    required this.slug,
    required this.author,
    this.description,
    required this.metrics,
    required this.comments,
    required this.likers,
    required this.createdAt,
    this.imageUrl,
    required this.likedFeed,
  });
}

class FeedMetric {
  final String exerciseId;
  final String exerciseName;
  final int displayOrder;
  final List<FeedMetricItem> setList;

  const FeedMetric({
    required this.exerciseId,
    required this.exerciseName,
    required this.displayOrder,
    required this.setList,
  });
}

class FeedMetricItem {
  final int set;
  final int rep;
  final double weight;
  final String? memo;

  const FeedMetricItem({
    required this.set,
    required this.rep,
    required this.weight,
    this.memo,
  });
}

class Author {
  final String nickname;
  final String slug;
  final String? imageUrl;

  const Author({required this.nickname, required this.slug, this.imageUrl});
}

class FeedComment {
  final String slug;
  final String nickname;
  final String? imageUrl;
  final int commentId;
  final String comment;
  final DateTime createdAt;
  final bool isMine;

  const FeedComment({
    required this.slug,
    required this.nickname,
    this.imageUrl,
    required this.commentId,
    required this.comment,
    required this.createdAt,
    required this.isMine,
  });
}

class FeedLiker {
  final String slug;
  final String nickname;
  final String? imageUrl;

  const FeedLiker({required this.slug, required this.nickname, this.imageUrl});
}
