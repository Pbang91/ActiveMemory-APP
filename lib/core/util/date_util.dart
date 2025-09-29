import 'package:intl/intl.dart';

class DateUtil {
  /// 다양한 날짜 형식을 파싱하여 DateTime으로 변환
  static DateTime parseServerDateTime(String dateString) {
    // 공백 제거
    dateString = dateString.trim();

    try {
      // ISO 8601 형식 (2024-01-15T10:30:00 또는 2024-01-15T10:30:00.123)
      if (dateString.contains('T')) {
        // Z나 타임존 정보가 없으면 로컬 시간으로 처리
        if (!dateString.contains('Z') &&
            !dateString.contains('+') &&
            !dateString.contains('-', 10)) {
          return DateTime.parse('${dateString}Z').toLocal();
        }
        return DateTime.parse(dateString).toLocal();
      }

      // LocalDate 형식 (2024-01-15)
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateString)) {
        return DateTime.parse('${dateString}T00:00:00');
      }

      // LocalDateTime 형식 (2024-01-15 10:30:00 또는 2024-01-15 10:30:00.123)
      if (dateString.contains(' ')) {
        final replaced = dateString.replaceFirst(' ', 'T');
        return DateTime.parse(replaced);
      }

      // 기본 파싱 시도
      return DateTime.parse(dateString);
    } catch (e) {
      print('날짜 파싱 실패: $dateString, 오류: $e');
      // 파싱 실패 시 현재 시간 반환
      return DateTime.now();
    }
  }

  /// 상대적 시간 문자열 반환
  static String getRelativeTimeString(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    // 1분 미만: 방금 전
    if (difference.inMinutes < 1) {
      return '방금 전';
    }

    // 1시간 미만: N분 전
    if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    }

    // 24시간 이내: N시간 전
    if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    }

    // 1일 ~ 7일 이내: N일 전
    if (difference.inDays <= 7) {
      return '${difference.inDays}일 전';
    }

    // 7일 이후, 같은 해: MM월 DD일
    if (createdAt.year == now.year) {
      return DateFormat('MM월 dd일').format(createdAt);
    }

    // 연도가 지난 경우: YYYY년 MM월 DD일
    return DateFormat('yyyy년 MM월 dd일').format(createdAt);
  }

  /// 절대적 시간 문자열 반환 (상세 정보용)
  static String getAbsoluteTimeString(DateTime dateTime) {
    return DateFormat('yyyy년 MM월 dd일 HH:mm').format(dateTime);
  }

  /// 날짜만 반환 (LocalDate 대응)
  static String getDateString(DateTime dateTime) {
    return DateFormat('yyyy년 MM월 dd일').format(dateTime);
  }

  /// 시간만 반환
  static String getTimeString(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// 서버 형식에 맞는 문자열로 변환 (전송용)
  static String toServerDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
  }

  /// 서버 형식에 맞는 날짜 문자열로 변환 (LocalDate용)
  static String toServerDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
}
