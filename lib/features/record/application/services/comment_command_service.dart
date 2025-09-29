import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentCommandServiceProvider = Provider<CommentCommandService>((ref) {
  return CommentCommandService();
});

class CommentCommandService {
  // 댓글 작성 (Command - Record 도메인)
  Future<void> createComment({
    required String recordId,
    required String content,
  }) async {
    // TODO: Record 도메인 API 호출
    // POST /api/records/{recordId}/comments
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // 댓글 삭제 (Command - Record 도메인)
  Future<void> deleteComment({
    required String recordId,
    required String commentId,
  }) async {
    // TODO: Record 도메인 API 호출
    // DELETE /api/records/{recordId}/comments/{commentId}
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
