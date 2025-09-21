import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
      debugPrint('DioException 발생: ${e.type} - ${e.message}');
      debugPrint('API 호출 실패, 목업 데이터 반환');
      return _getMockFeeds(page: page, limit: limit);
    } catch (e) {
      debugPrint('기타 오류 발생: $e');
      debugPrint('목업 데이터 반환');
      return _getMockFeeds(page: page, limit: limit);
    }
  }

  /// 키워드로 피드 검색
  Future<List<Feed>> searchFeeds(
    String keyword, {
    int page = 0,
    int limit = 20,
  }) async {
    debugPrint(
      'FeedService.searchFeeds 호출 - keyword: $keyword, page: $page, limit: $limit',
    );

    try {
      debugPrint('검색 API 요청 시도: ${_dio.options.baseUrl}/feeds/search');

      final response = await _dio.get(
        '/feeds/search',
        queryParameters: {'keyword': keyword, 'page': page, 'limit': limit},
      );

      debugPrint('검색 API 응답 성공 - statusCode: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data as List<dynamic>;
        final List<FeedListDto> dtoList = jsonList
            .map((json) => FeedListDto.fromJson(json as Map<String, dynamic>))
            .toList();

        final feeds = FeedMapper.fromDtoList(dtoList);
        debugPrint('검색 결과 변환 완료 - feeds 개수: ${feeds.length}');
        return feeds;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to search feeds: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      debugPrint('검색 DioException 발생: ${e.type} - ${e.message}');
      debugPrint('검색 API 호출 실패, 목업 데이터에서 검색');
      return _searchMockFeeds(keyword, page: page, limit: limit);
    } catch (e) {
      debugPrint('검색 기타 오류 발생: $e');
      debugPrint('목업 데이터에서 검색');
      return _searchMockFeeds(keyword, page: page, limit: limit);
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
    print('목업 데이터 생성 - page: $page, limit: $limit');

    final allMockFeeds = List.generate(50, (index) {
      return Feed(
        name: '운동 기록 ${index + 1}',
        slug: 'workout-${index + 1}',
        description: index % 3 == 0
            ? null
            : '오늘의 운동 기록입니다. 정말 힘들었지만 보람찬 하루였어요!',
        metrics: [
          FeedMetric(
            exerciseId: 'exercise-${index * 2 + 1}',
            exerciseName: index % 2 == 0 ? '벨트 스쿼트' : '데드리프트',
            displayOrder: 1,
          ),
          if (index % 3 == 0)
            FeedMetric(
              exerciseId: 'exercise-${index * 2 + 2}',
              exerciseName: '벤치프레스',
              displayOrder: 2,
            ),
        ],
        commentCount: (index * 3) % 10,
        likeCount: (index * 7) % 50,
      );
    });

    final startIndex = page * limit;
    final endIndex = (startIndex + limit).clamp(0, allMockFeeds.length);

    if (startIndex >= allMockFeeds.length) {
      print('페이지 범위 초과 - 빈 리스트 반환');
      return [];
    }

    final result = allMockFeeds.sublist(startIndex, endIndex);
    print('목업 데이터 생성 완료 - ${result.length}개 반환');
    return result;
  }

  // 목업 데이터 검색 (개발용)
  List<Feed> _searchMockFeeds(String keyword, {int page = 0, int limit = 20}) {
    print('목업 데이터 검색 - keyword: $keyword, page: $page, limit: $limit');

    final allMockFeeds = _getMockFeeds(page: 0, limit: 50);
    final filteredFeeds = allMockFeeds.where((feed) {
      return feed.name.contains(keyword) ||
          (feed.description?.contains(keyword) ?? false) ||
          feed.metrics.any((metric) => metric.exerciseName.contains(keyword));
    }).toList();

    print('검색 결과 - ${filteredFeeds.length}개 찾음');

    final startIndex = page * limit;
    final endIndex = (startIndex + limit).clamp(0, filteredFeeds.length);

    if (startIndex >= filteredFeeds.length) {
      print('검색 페이지 범위 초과 - 빈 리스트 반환');
      return [];
    }

    final result = filteredFeeds.sublist(startIndex, endIndex);
    print('검색 목업 데이터 반환 - ${result.length}개');
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
      print('hasMoreFeeds 오류: $e');
      return false;
    }
  }
}

// FeedService Provider
final feedServiceProvider = Provider<FeedService>((ref) {
  final dio = ref.watch(dioProvider);
  return FeedService(dio);
});
