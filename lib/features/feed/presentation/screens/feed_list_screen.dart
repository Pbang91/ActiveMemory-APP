import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/feed.dart';
import '../../application/services/feed_service.dart';

class FeedListScreen extends ConsumerStatefulWidget {
  const FeedListScreen({super.key});

  @override
  ConsumerState<FeedListScreen> createState() => _FeedListScreenState();
}

class _FeedListScreenState extends ConsumerState<FeedListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Feed> _feeds = []; // 피드 목록
  bool _isLoading = false; // 전체 로딩 여부
  bool _isLoadingMore = false; // 추가 데이터 로딩 여부(무한 스크롤)
  bool _hasMoreData = true; // 더 불러올 데이터 있는지 여부
  int _currentPage = 0; // 현재 페이지
  String _currentSearchKeyword = ''; // 현재 검색 키워드
  bool _isInitialized = false; // 초기화 여부

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // 첫 프레임 렌더링 후 초기 로딩 수행
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized && mounted) {
        _isInitialized = true;
        _loadFeeds();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤 리스너 - 무한 스크롤 구현
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMoreFeeds();
    }
  }

  // 피드 목록 로드
  Future<void> _loadFeeds({bool isRefresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;

      if (isRefresh) {
        _feeds.clear();
        _currentPage = 0;
        _hasMoreData = true;
      }
    });

    try {
      final feedService = ref.read(feedServiceProvider);
      List<Feed> newFeeds;

      if (_currentSearchKeyword.isEmpty) {
        newFeeds = await feedService.getPublicFeeds(page: _currentPage);
      } else {
        newFeeds = await feedService.searchFeeds(
          _currentSearchKeyword,
          page: _currentPage,
        );
      }

      if (mounted) {
        setState(() {
          if (isRefresh) {
            _feeds = newFeeds;
          } else {
            _feeds.addAll(newFeeds);
          }
          _hasMoreData = newFeeds.length >= 20; // limit와 동일
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        _showErrorSnackBar('피드를 불러오는데 실패했습니다.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 더 많은 피드 로드 (무한 스크롤)
  Future<void> _loadMoreFeeds() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      _currentPage++;
      final feedService = ref.read(feedServiceProvider);
      List<Feed> newFeeds;

      if (_currentSearchKeyword.isEmpty) {
        newFeeds = await feedService.getPublicFeeds(page: _currentPage);
      } else {
        newFeeds = await feedService.searchFeeds(
          _currentSearchKeyword,
          page: _currentPage,
        );
      }

      if (mounted) {
        setState(() {
          _feeds.addAll(newFeeds);
          _hasMoreData = newFeeds.length >= 20;
        });
      }
    } catch (e) {
      _currentPage--; // 실패 시 페이지 번호 되돌리기
      if (mounted) {
        _showErrorSnackBar('더 많은 피드를 불러오는데 실패했습니다.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  // 에러 스낵바 표시 (안전한 방식)
  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    });
  }

  // 검색 실행
  void _performSearch(String keyword) {
    _currentSearchKeyword = keyword.trim();
    _currentPage = 0;
    _loadFeeds(isRefresh: true);
  }

  // 새로고침
  Future<void> _onRefresh() async {
    await _loadFeeds(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Memory'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // 로그인 화면으로 이동 (추후 실제 로그인 화면으로 연결)
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('로그인 기능 추후 구현 예정')));
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색창
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '키워드, 운동명으로 검색...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onSubmitted: _performSearch,
              onChanged: (value) {
                setState(() {}); // suffixIcon 업데이트를 위해
              },
            ),
          ),

          // 피드 리스트
          Expanded(
            child: _isLoading && _feeds.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _feeds.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.feed_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentSearchKeyword.isEmpty
                              ? '표시할 피드가 없습니다'
                              : '검색 결과가 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _feeds.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _feeds.length) {
                          // 로딩 인디케이터
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final feed = _feeds[index];
                        return _FeedCard(feed: feed);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// 피드 카드 위젯
class _FeedCard extends StatelessWidget {
  final Feed feed;

  const _FeedCard({required this.feed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 기록 이름
            Text(
              feed.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 설명 (있는 경우)
            if (feed.description != null) ...[
              Text(
                feed.description!,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
            ],

            // 운동 목록
            if (feed.metrics.isNotEmpty) ...[
              const Text(
                '운동 항목',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              ...feed.metrics.map((metric) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        metric.exerciseName,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],

            // 좋아요, 댓글 수
            Row(
              children: [
                Icon(Icons.favorite_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${feed.likeCount}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.comment_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${feed.commentCount}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
