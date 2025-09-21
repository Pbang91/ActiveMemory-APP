import '../models/feed_dto.dart';
import '../../domain/entities/feed.dart';

class FeedMapper {
  static Feed fromDto(FeedListDto dto) {
    return Feed(
      name: dto.name,
      slug: dto.slug,
      description: dto.freeInput,
      metrics: dto.metricList.map(_mapMetric).toList(),
      commentCount: dto.commentCount,
      likeCount: dto.likeCount,
    );
  }

  static FeedMetric _mapMetric(FeedMetricDto dto) {
    return FeedMetric(
      exerciseId: dto.exerciseId,
      exerciseName: dto.exerciseName,
      displayOrder: dto.displayOrder,
    );
  }

  static List<Feed> fromDtoList(List<FeedListDto> dtoList) {
    return dtoList.map(fromDto).toList();
  }
}
