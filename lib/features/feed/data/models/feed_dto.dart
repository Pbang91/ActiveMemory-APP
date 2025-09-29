class FeedListDto {
  final String slug;
  final String? freeInput;
  final AuthorProfileDto author;
  final List<FeedMetricDto> metricList;
  final List<FeedCommentDto> commentList;
  final List<FeedLikerDto> likerList;
  final String createdAt;
  final String? imageUrl;
  final bool likedFeed;

  const FeedListDto({
    required this.slug,
    this.freeInput,
    required this.author,
    required this.metricList,
    required this.commentList,
    required this.likerList,
    required this.createdAt,
    this.imageUrl,
    this.likedFeed = false,
  });

  factory FeedListDto.fromJson(Map<String, dynamic> json) {
    return FeedListDto(
      slug: json['slug'] as String,
      author: AuthorProfileDto.fromJson(
        json['authorProfile'] as Map<String, dynamic>,
      ),
      freeInput: json['freeInput'] as String?,
      metricList:
          (json['metricList'] as List<dynamic>?)
              ?.map(
                (item) => FeedMetricDto.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      commentList:
          (json['commentList'] as List<dynamic>?)
              ?.map(
                (item) => FeedCommentDto.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      likerList:
          (json['likerList'] as List<dynamic>?)
              ?.map(
                (item) => FeedLikerDto.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: json['createdAt'] as String,
      imageUrl: json['imageUrl'] as String?,
      likedFeed: json['likedFeed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'freeInput': freeInput,
      'metricList': metricList.map((metric) => metric.toJson()).toList(),
      'commentList': commentList.map((comment) => comment.toJson()).toList(),
      'likerList': likerList.map((liker) => liker.toJson()).toList(),
      'autorProfile': author.toJson(),
      'createdAt': createdAt,
      'imageUrl': imageUrl,
      'likedFeed': likedFeed,
    };
  }
}

class AuthorProfileDto {
  final String nickname;
  final String? imageUrl;
  final String slug;

  const AuthorProfileDto({
    required this.nickname,
    this.imageUrl,
    required this.slug,
  });

  factory AuthorProfileDto.fromJson(Map<String, dynamic> json) {
    return AuthorProfileDto(
      nickname: json['nickname'] as String,
      imageUrl: json['imageUrl'] as String?,
      slug: json['slug'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nickname': nickname, 'imageUrl': imageUrl, 'slug': slug};
  }
}

class FeedMetricItemDto {
  final int set;
  final int rep;
  final double weight;
  final String? memo;

  const FeedMetricItemDto({
    required this.set,
    required this.rep,
    required this.weight,
    this.memo,
  });

  factory FeedMetricItemDto.fromJson(Map<String, dynamic> json) {
    return FeedMetricItemDto(
      set: json['set'] as int,
      rep: json['rep'] as int,
      weight: (json['weight'] as num).toDouble(),
      memo: json['memo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'set': set, 'rep': rep, 'weight': weight, 'memo': memo};
  }
}

class FeedMetricDto {
  final String exerciseId; // UUID 형식
  final String exerciseName;
  final int displayOrder;
  final List<FeedMetricItemDto> setList;

  const FeedMetricDto({
    required this.exerciseId,
    required this.exerciseName,
    required this.displayOrder,
    required this.setList,
  });

  factory FeedMetricDto.fromJson(Map<String, dynamic> json) {
    return FeedMetricDto(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      displayOrder: json['displayOrder'] as int,
      setList: (json['setList'] as List<dynamic>)
          .map(
            (item) => FeedMetricItemDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'displayOrder': displayOrder,
      'setList': setList.map((item) => item.toJson()).toList(),
    };
  }
}

class FeedCommentDto {
  final String slug;
  final String nickname;
  final String? imageUrl;
  final int commentId;
  final String comment;
  final String createdAt;
  final bool isMine;

  const FeedCommentDto({
    required this.slug,
    required this.nickname,
    this.imageUrl,
    required this.commentId,
    required this.comment,
    required this.createdAt,
    this.isMine = false,
  });

  factory FeedCommentDto.fromJson(Map<String, dynamic> json) {
    return FeedCommentDto(
      slug: json['slug'] as String,
      nickname: json['nickname'] as String,
      imageUrl: json['imageUrl'] as String?,
      commentId: json['commentId'] as int,
      comment: json['comment'] as String,
      createdAt: json['createdAt'] as String,
      isMine: json['isMine'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'nickname': nickname,
      'imageUrl': imageUrl,
      'commentId': commentId,
      'comment': comment,
      'createdAt': createdAt,
      'isMine': isMine,
    };
  }
}

class FeedLikerDto {
  final String slug;
  final String nickname;
  final String? imageUrl;

  const FeedLikerDto({
    required this.slug,
    required this.nickname,
    this.imageUrl,
  });

  factory FeedLikerDto.fromJson(Map<String, dynamic> json) {
    return FeedLikerDto(
      slug: json['slug'] as String,
      nickname: json['nickname'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'slug': slug, 'nickname': nickname, 'imageUrl': imageUrl};
  }
}
