import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../../domain/entities/feed.dart';
import '../../data/models/feed_dto.dart';
import '../../data/mappers/feed_mapper.dart';

class FeedService {
  final Dio _dio;

  FeedService(this._dio);

  /// 공개 피드 목록 조회
  Future<List<Feed>> getPublicFeeds({int page = 0, int limit = 20}) async {
    try {
      final response = await _dio.get(
        '/feeds',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data as List<dynamic>;
        final List<FeedListDto> dtoList = jsonList
            .map((json) => FeedListDto.fromJson(json as Map<String, dynamic>))
            .toList();

        final feeds = FeedMapper.fromDtoList(dtoList);

        return feeds;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load feeds: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      return _getMockFeeds(page: page, limit: limit);
    } catch (e) {
      return _getMockFeeds(page: page, limit: limit);
    }
  }

  /// 특정 피드 상세 조회
  Future<Feed?> getFeedById(String slug) async {
    print('FeedService.getFeedById 호출 - slug: $slug');

    try {
      print('피드 상세 API 요청 시도: ${_dio.options.baseUrl}/feeds/$slug');

      final response = await _dio.get('/feeds/$slug');

      print('피드 상세 API 응답 성공 - statusCode: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        final dto = FeedListDto.fromJson(json);
        final feed = FeedMapper.fromDto(dto);
        print('피드 상세 변환 완료');
        return feed;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load feed: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('피드 상세 DioException 발생: ${e.type} - ${e.message}');
      print('피드 상세 API 호출 실패, 목업 데이터 반환');
      final mockFeeds = _getMockFeeds();
      return mockFeeds.firstWhere(
        (feed) => feed.slug == slug,
        orElse: () => mockFeeds.first,
      );
    } catch (e) {
      print('피드 상세 기타 오류 발생: $e');
      print('목업 데이터 반환');
      final mockFeeds = _getMockFeeds();
      return mockFeeds.firstWhere(
        (feed) => feed.slug == slug,
        orElse: () => mockFeeds.first,
      );
    }
  }

  // 목업 데이터 생성 (개발용)
  List<Feed> _getMockFeeds({int page = 0, int limit = 20}) {
    final now = DateTime.now();

    final allMockFeeds = List.generate(50, (index) {
      DateTime createdAt;

      switch (index % 8) {
        case 0: // 방금 전
          createdAt = now.subtract(const Duration(seconds: 30));
          break;
        case 1: // N분 전
          createdAt = now.subtract(Duration(minutes: 15 + (index % 45)));
          break;
        case 2: // N시간 전
          createdAt = now.subtract(Duration(hours: 2 + (index % 22)));
          break;
        case 3: // N일 전 (1-7일)
          createdAt = now.subtract(Duration(days: 1 + (index % 7)));
          break;
        case 4: // 이번 년도
          createdAt = DateTime(now.year, (index % 12) + 1, (index % 28) + 1);
          break;
        case 5: // 작년
          createdAt = DateTime(
            now.year - 1,
            (index % 12) + 1,
            (index % 28) + 1,
          );
          break;
        default: // 랜덤
          createdAt = now.subtract(Duration(days: index % 365));
      }

      return Feed(
        slug: 'workout-${index + 1}',
        author: Author(
          nickname: '사용자${index + 1}',
          slug: 'user-adfnq-${index + 1}',
          imageUrl: index % 2 == 0
              ? 'https://i.pravatar.cc/150?img=${index + 1}'
              : null,
        ),
        description: index % 3 == 0
            ? null
            : '오늘의 운동 기록입니다. 정말 힘들었지만 보람찬 하루였어요!',
        metrics: [
          FeedMetric(
            exerciseId: 'exercise-${index * 2 + 1}',
            exerciseName: index % 2 == 0 ? '벨트 스쿼트' : '데드리프트',
            displayOrder: 1,
            setList: List.generate(3, (setIndex) {
              return FeedMetricItem(
                set: setIndex + 1,
                rep: 8 + (setIndex * 2),
                weight: 20.0 + (setIndex * 5),
                memo: setIndex == 2 ? '마지막 세트 힘들었어요' : null,
              );
            }),
          ),
          if (index % 3 == 0)
            FeedMetric(
              exerciseId: 'exercise-${index * 2 + 2}',
              exerciseName: '벤치프레스',
              displayOrder: 2,
              setList: List.generate(3, (setIndex) {
                return FeedMetricItem(
                  set: setIndex + 1,
                  rep: 10,
                  weight: 15.0 + (setIndex * 5),
                  memo: null,
                );
              }),
            ),
        ],
        comments: List.generate(index % 5, (commentIndex) {
          return FeedComment(
            slug: 'user-commenter-${commentIndex + 1}',
            nickname: '댓글러${commentIndex + 1}',
            imageUrl: commentIndex % 2 == 0
                ? 'https://i.pravatar.cc/150?img=${commentIndex + 10}'
                : null,
            commentId: commentIndex + 1,
            comment: '멋진 기록이네요! 저도 열심히 해야겠어요.',
            createdAt: createdAt.subtract(
              Duration(minutes: (commentIndex + 1) * 5),
            ),
            isMine: commentIndex % 4 == 0, // 4번째 댓글은 내가 쓴 댓글
          );
        }),
        likers: List.generate(index % 10, (likerIndex) {
          return FeedLiker(
            slug: 'user-liker-${likerIndex + 1}',
            nickname: '좋아요러${likerIndex + 1}',
            imageUrl: likerIndex % 2 == 0
                ? 'https://i.pravatar.cc/150?img=${likerIndex + 20}'
                : null,
          );
        }),
        imageUrl: index % 4 == 0
            ? 'https://picsum.photos/400/300?random=$index'
            : null,
        createdAt: createdAt,
        likedFeed: index % 3 == 0,
      );
    });

    final startIndex = page * limit;
    final endIndex = (startIndex + limit).clamp(0, allMockFeeds.length);

    if (startIndex >= allMockFeeds.length) {
      return [];
    }

    final result = allMockFeeds.sublist(startIndex, endIndex);

    return result;
  }

  /// 더 많은 피드가 있는지 확인
  Future<bool> hasMoreFeeds(int currentPage, int limit) async {
    try {
      final nextPageFeeds = await getPublicFeeds(
        page: currentPage + 1,
        limit: limit,
      );
      return nextPageFeeds.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

// FeedService Provider
final feedServiceProvider = Provider<FeedService>((ref) {
  final dio = ref.watch(dioProvider);
  return FeedService(dio);
});
