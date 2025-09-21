import 'package:flutter/material.dart';
import '../../application/services/kakao_login_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // 앱 시작 시 로그인 상태 확인
  Future<void> _checkLoginStatus() async {
    final userInfo = await KakaoLoginService.getCurrentUser();
    if (userInfo != null) {
      setState(() {
        _userInfo = userInfo;
      });
    }
  }

  // 카카오 로그인
  Future<void> _loginWithKakao() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userInfo = await KakaoLoginService.login();
      if (userInfo != null) {
        setState(() {
          _userInfo = userInfo;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${userInfo['nickname']}님, 환영합니다!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('로그인에 실패했습니다.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 로그아웃
  Future<void> _logout() async {
    final success = await KakaoLoginService.logout();
    if (success) {
      setState(() {
        _userInfo = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그아웃되었습니다.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카카오 로그인'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 제목
            const Icon(Icons.memory, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'Active Memory',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),

            // 로그인되지 않은 상태
            if (_userInfo == null) ...[
              const Text(
                '카카오 계정으로 로그인하세요',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _loginWithKakao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE812), // 카카오 옐로우
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black54,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '카카오로 로그인',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],

            // 로그인된 상태
            if (_userInfo != null) ...[
              // 프로필 이미지
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _userInfo!['profileImageUrl'] != null
                    ? NetworkImage(_userInfo!['profileImageUrl'])
                    : null,
                child: _userInfo!['profileImageUrl'] == null
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 16),

              // 사용자 정보
              Text(
                _userInfo!['nickname'] ?? '닉네임 없음',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (_userInfo!['email'] != null)
                Text(
                  _userInfo!['email'],
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'ID: ${_userInfo!['id']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 로그아웃 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _logout,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('로그아웃', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
