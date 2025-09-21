class FeedListDto {
  final String name;
  final String slug;
  final String? freeInput;
  final List<FeedMetricDto> metricList;
  final int commentCount;
  final int likeCount;

  const FeedListDto({
    required this.name,
    required this.slug,
    this.freeInput,
    required this.metricList,
    required this.commentCount,
    required this.likeCount,
  });

  factory FeedListDto.fromJson(Map<String, dynamic> json) {
    return FeedListDto(
      name: json['name'] as String,
      slug: json['slug'] as String,
      freeInput: json['freeInput'] as String?,
      metricList:
          (json['metricList'] as List<dynamic>?)
              ?.map(
                (item) => FeedMetricDto.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      commentCount: json['commentCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'freeInput': freeInput,
      'metricList': metricList.map((metric) => metric.toJson()).toList(),
      'commentCount': commentCount,
      'likeCount': likeCount,
    };
  }
}

class FeedMetricDto {
  final String exerciseId; // UUID 형식
  final String exerciseName;
  final int displayOrder;

  const FeedMetricDto({
    required this.exerciseId,
    required this.exerciseName,
    required this.displayOrder,
  });

  factory FeedMetricDto.fromJson(Map<String, dynamic> json) {
    return FeedMetricDto(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      displayOrder: json['displayOrder'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'displayOrder': displayOrder,
    };
  }
}
