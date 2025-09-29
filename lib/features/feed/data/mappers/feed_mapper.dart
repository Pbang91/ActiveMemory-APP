import 'package:active_memory/core/util/date_util.dart';

import '../models/feed_dto.dart';
import '../../domain/entities/feed.dart';

class FeedMapper {
  static Feed fromDto(FeedListDto dto) {
    return Feed(
      slug: dto.slug,
      description: dto.freeInput,
      author: _mapAuthor(dto.author),
      metrics: dto.metricList.map(_mapMetric).toList(),
      comments: dto.commentList.map(_mapComment).toList(),
      likers: dto.likerList.map(_mapLiker).toList(),
      createdAt: DateUtil.parseServerDateTime(dto.createdAt),
      imageUrl: dto.imageUrl,
      likedFeed: dto.likedFeed,
    );
  }

  static Author _mapAuthor(AuthorProfileDto dto) {
    return Author(
      nickname: dto.nickname,
      slug: dto.slug,
      imageUrl: dto.imageUrl,
    );
  }

  static FeedMetric _mapMetric(FeedMetricDto dto) {
    return FeedMetric(
      exerciseId: dto.exerciseId,
      exerciseName: dto.exerciseName,
      displayOrder: dto.displayOrder,
      setList: dto.setList
          .map(
            (item) => FeedMetricItem(
              set: item.set,
              rep: item.rep,
              weight: item.weight,
              memo: item.memo,
            ),
          )
          .toList(),
    );
  }

  static FeedComment _mapComment(FeedCommentDto dto) {
    return FeedComment(
      slug: dto.slug,
      nickname: dto.nickname,
      imageUrl: dto.imageUrl,
      commentId: dto.commentId,
      comment: dto.comment,
      createdAt: DateUtil.parseServerDateTime(dto.createdAt),
      isMine: dto.isMine,
    );
  }

  static FeedLiker _mapLiker(FeedLikerDto dto) {
    return FeedLiker(
      slug: dto.slug,
      nickname: dto.nickname,
      imageUrl: dto.imageUrl,
    );
  }

  static List<Feed> fromDtoList(List<FeedListDto> dtoList) {
    return dtoList.map(fromDto).toList();
  }
}
