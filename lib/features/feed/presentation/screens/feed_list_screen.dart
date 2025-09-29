import 'package:active_memory/core/util/date_util.dart';
import 'package:active_memory/features/auth/application/auth_notifier.dart';
import 'package:active_memory/features/auth/presentation/screens/login_screen.dart';
import 'package:active_memory/features/auth/presentation/widgets/login_dialog.dart';
import 'package:active_memory/features/feed/presentation/widgets/comment_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/common_app_bar.dart';
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

  List<Feed> _feeds = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 0;
  bool _isInitialized = false;

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

      newFeeds = await feedService.getPublicFeeds(page: _currentPage);

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
    } catch (e, stackTrace) {
      debugPrint("오류 발생: $e");
      debugPrint("스택 트레이스: $stackTrace");

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

      newFeeds = await feedService.getPublicFeeds(page: _currentPage);

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

  // 에러 스낵바 표시
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

  // 새로고침
  Future<void> _onRefresh() async {
    await _loadFeeds(isRefresh: true);
  }

  // 로그인 버튼 클릭
  void _onLoginTap() {
    // TODO: 로그인 화면으로 이동
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('로그인 화면으로 이동 예정')));
  }

  // 알림 버튼 클릭
  void _onNotificationTap() {
    // TODO: 알림 화면으로 이동
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('알림 화면으로 이동 예정')));
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return Scaffold(
      appBar: CommonAppBar(
        type: AppBarType.feed,
        isLoggedIn: isLoggedIn,
        onLoginTap: _onLoginTap,
        onNotificationTap: _onNotificationTap,
      ),
      body: Column(
        children: [
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
                          '표시할 피드가 없습니다',
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
      // 로그인 상태 디버그용 FloatingActionButton (개발 중에만 사용)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 로그인/로그아웃 토글 (테스트용)
          final authNotifier = ref.read(authProvider.notifier);
          if (isLoggedIn) {
            authNotifier.logout();
          } else {
            authNotifier.login(nickname: '테스트 사용자', slug: 'qweqwe12s');
          }
        },
        child: Icon(isLoggedIn ? Icons.logout : Icons.login),
      ),
    );
  }
}

// 피드 카드 위젯
class _FeedCard extends ConsumerStatefulWidget {
  final Feed feed;

  const _FeedCard({required this.feed});

  @override
  ConsumerState<_FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends ConsumerState<_FeedCard> {
  bool _isDescriptionExpanded = false;
  final Map<String, bool> _expandedMetrics = {}; // 각 운동별 확장 상태
  static const int _maxDescriptionLength = 500;

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
            // 작성자 정보
            _buildAuthorInfo(),
            const SizedBox(height: 12),

            // 설명 (있는 경우)
            if (widget.feed.description != null) ...[
              _buildDescription(),
              const SizedBox(height: 12),
            ],

            // 운동 목록
            if (widget.feed.metrics.isNotEmpty) ...[
              _buildMetrics(),
              const SizedBox(height: 12),
            ],

            if (widget.feed.imageUrl != null) ...[
              _buildImage(),
              const SizedBox(height: 12),
            ],

            _buildActionButtons(),
            const SizedBox(height: 8),

            if (widget.feed.likers.isNotEmpty) ...[
              _buildLikers(),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: widget.feed.author.imageUrl != null
              ? NetworkImage(widget.feed.author.imageUrl!)
              : null,
          child: Text(
            widget.feed.author.nickname.isNotEmpty
                ? widget.feed.author.nickname[0]
                : '?',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.feed.author.nickname,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                DateUtil.getRelativeTimeString(widget.feed.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    final description = widget.feed.description!;
    final isLongText = description.length > _maxDescriptionLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isDescriptionExpanded || !isLongText
              ? description
              : '${description.substring(0, _maxDescriptionLength)}...',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        if (isLongText) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Text(
              _isDescriptionExpanded ? '접기' : '더보기',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.feed.metrics.map((metric) {
        final isExpanded = _expandedMetrics[metric.exerciseId] ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _expandedMetrics[metric.exerciseId] = !isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
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
                    Expanded(
                      child: Text(
                        '${metric.exerciseName} (${metric.setList.length}set)',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
            // 운동 세부 정보 (확장 시 표시)
            if (isExpanded) ...[
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.only(left: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: metric.setList.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text(
                            '${item.set}세트',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${item.weight}kg × ${item.rep}회',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        );
      }).toList(),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        widget.feed.imageUrl!,
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text('이미지를 불러올 수 없습니다', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // 좋아요
        Expanded(
          child: InkWell(
            onTap: () async {
              final isLoggedIn = ref.watch(isLoggedInProvider);

              if (!isLoggedIn) {
                final shouldLogin = await LoginDialog.show(context, '좋아요');

                if (shouldLogin == true && mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }

                return;
              }

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('좋아요 기능 준비중')));
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.feed.likers.isEmpty
                        ? Icons.favorite_outline
                        : widget.feed.likedFeed
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    size: 18,
                    color: widget.feed.likers.isEmpty
                        ? Colors.grey[600]
                        : widget.feed.likedFeed
                        ? Colors.red
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.feed.likers.length}',
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.feed.likers.isEmpty
                          ? Colors.grey[600]
                          : widget.feed.likedFeed
                          ? Colors.red
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 구분선
        Container(height: 20, width: 1, color: Colors.grey[300]),

        // 댓글
        Expanded(
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => CommentBottomSheet(feed: widget.feed),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.feed.comments.length}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 구분선
        Container(height: 20, width: 1, color: Colors.grey[300]),

        // 공유하기
        Expanded(
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('공유 기능 준비중')));
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share_outlined, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '공유',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLikers() {
    final displayLikers = widget.feed.likers.take(3).toList(); // 최대 3명까지

    return Row(
      children: [
        // 좋아요 한 사용자들의 프로필 이미지 (최대 3명)
        SizedBox(
          width: displayLikers.length * 20.0, // 겹치는 효과를 위한 계산
          height: 24,
          child: Stack(
            children: displayLikers.asMap().entries.map((entry) {
              final index = entry.key;
              final liker = entry.value;

              return Positioned(
                left: index * 16.0, // 4px씩 겹치게
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundImage: liker.imageUrl != null
                        ? NetworkImage(liker.imageUrl!)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: liker.imageUrl == null
                        ? Text(
                            liker.nickname.isNotEmpty
                                ? liker.nickname[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 8),
        // 좋아요 텍스트
        Text(
          '${widget.feed.likers.length}명이 좋아합니다',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
