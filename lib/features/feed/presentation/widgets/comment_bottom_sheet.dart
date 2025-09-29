import 'package:active_memory/core/util/date_util.dart';
import 'package:active_memory/features/auth/application/auth_notifier.dart';
import 'package:active_memory/features/auth/presentation/screens/login_screen.dart';
import 'package:active_memory/features/auth/presentation/widgets/login_dialog.dart';
import 'package:active_memory/features/feed/domain/entities/feed.dart';
import 'package:active_memory/features/record/application/services/comment_command_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentBottomSheet extends ConsumerStatefulWidget {
  final Feed feed; // Feed 객체 전체 전달

  const CommentBottomSheet({super.key, required this.feed});

  @override
  ConsumerState<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends ConsumerState<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  late List<FeedComment> _comments;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // 초기 댓글 목록은 Feed에서 가져온 데이터 사용
    _comments = List.from(widget.feed.comments);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginAndAddComment() async {
    final isLoggedIn = ref.read(isLoggedInProvider);

    if (!isLoggedIn) {
      // 로그인되지 않은 경우 로그인 유도 모달 표시
      final shouldLogin = await LoginDialog.show(context, '댓글 작성');

      if (shouldLogin == true && mounted) {
        // 로그인 화면으로 이동
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
      return;
    }

    // 로그인된 경우 댓글 작성 진행
    await _addComment();
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty || _isSubmitting) return;

    final content = _commentController.text.trim();

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Record 도메인의 Command Service 사용
      final commentCommandService = ref.read(commentCommandServiceProvider);
      await commentCommandService.createComment(
        recordId: widget.feed.slug, // Feed의 id가 recordId 역할
        content: content,
      );

      // 성공 시 로컬 상태 업데이트
      final newComment = FeedComment(
        slug: 'temp-slug-${DateTime.now().millisecondsSinceEpoch}',
        commentId: DateTime.now().millisecondsSinceEpoch, // 임시 ID
        nickname: '현재사용자', // TODO: 실제 사용자 정보
        comment: content,
        imageUrl: null,
        createdAt: DateTime.now(),
        isMine: true,
      );

      setState(() {
        _comments.add(newComment);
        _commentController.clear();
      });

      FocusScope.of(context).unfocus();

      // 성공 메시지
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('댓글이 작성되었습니다')));
      }
    } catch (e) {
      // 실패 시 에러 메시지
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('댓글 작성에 실패했습니다'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // 상단 핸들
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 제목 영역
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  '댓글',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${_comments.length}개',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const Divider(thickness: 1),

          // 댓글 목록
          Expanded(
            child: _comments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '첫 번째 댓글을 남겨보세요!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      return _CommentItem(
                        comment: _comments[index],
                        recordId: widget.feed.slug,
                        onDelete: () {
                          setState(() {
                            _comments.removeAt(index);
                          });
                        },
                      );
                    },
                  ),
          ),

          // 댓글 입력 영역
          _buildCommentInput(isLoggedIn),
        ],
      ),
    );
  }

  Widget _buildCommentInput(bool isLoggedIn) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Text(
                isLoggedIn ? '나' : '?',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isLoggedIn ? Colors.grey[100] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _commentController,
                  enabled: !_isSubmitting && isLoggedIn,
                  decoration: InputDecoration(
                    hintText: isLoggedIn
                        ? '댓글을 입력하세요...'
                        : '로그인 후 댓글을 작성할 수 있습니다',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _checkLoginAndAddComment(),
                  onTap: !isLoggedIn ? () => _checkLoginAndAddComment() : null,
                  readOnly: !isLoggedIn,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: (_isSubmitting || !isLoggedIn)
                  ? null
                  : _checkLoginAndAddComment,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        Icons.send,
                        color: isLoggedIn ? Colors.blue[600] : Colors.grey[400],
                        size: 24,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 댓글 아이템 위젯
class _CommentItem extends ConsumerWidget {
  final FeedComment comment;
  final String recordId;
  final VoidCallback onDelete;

  const _CommentItem({
    required this.comment,
    required this.recordId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: comment.imageUrl != null
                ? NetworkImage(comment.imageUrl!)
                : null,
            backgroundColor: Colors.grey[300],
            child: comment.imageUrl == null
                ? Text(
                    comment.nickname.isNotEmpty
                        ? comment.nickname[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.nickname,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateUtil.getRelativeTimeString(comment.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.comment, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),

          if (comment.isMine)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 16, color: Colors.grey[400]),
              onSelected: (value) async {
                if (value == 'delete') {
                  // Record 도메인의 Command Service 사용
                  try {
                    final commentCommandService = ref.read(
                      commentCommandServiceProvider,
                    );
                    await commentCommandService.deleteComment(
                      recordId: recordId,
                      commentId: 'comment-id', // TODO: 실제 댓글 ID
                    );
                    onDelete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('댓글이 삭제되었습니다')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('댓글 삭제에 실패했습니다'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'delete', child: Text('삭제')),
              ],
            ),
        ],
      ),
    );
  }
}
