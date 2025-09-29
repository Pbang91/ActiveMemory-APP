import 'package:flutter/material.dart';

enum AppBarType { feed, record, myPage }

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarType type;
  final bool isLoggedIn;
  final VoidCallback? onLoginTap;
  final VoidCallback? onNotificationTap;
  final List<Widget> additionalActions;

  const CommonAppBar({
    super.key,
    required this.type,
    this.isLoggedIn = false,
    this.onLoginTap,
    this.onNotificationTap,
    this.additionalActions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_getTitle()),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
      actions: [
        ...buildActions(),
        if (additionalActions.isNotEmpty) ...additionalActions,
      ],
    );
  }

  String _getTitle() {
    switch (type) {
      case AppBarType.feed:
        return '피드';
      case AppBarType.record:
        return '기록';
      case AppBarType.myPage:
        return '마이페이지';
    }
  }

  List<Widget> buildActions() {
    List<Widget> actions = [];

    if (isLoggedIn) {
      switch (type) {
        case AppBarType.feed:
          actions.addAll([
            IconButton(
              onPressed: onNotificationTap,
              icon: const Icon(Icons.notifications),
              tooltip: '알림',
            ),
          ]);
          break;

        case AppBarType.record:
          actions.addAll([
            IconButton(
              onPressed: () {
                // 기록 관련 설정
              },
              icon: const Icon(Icons.settings_outlined),
              tooltip: '설정',
            ),
            IconButton(
              onPressed: onNotificationTap,
              icon: const Icon(Icons.notifications),
              tooltip: '알림',
            ),
          ]);
          break;
        case AppBarType.myPage:
          actions.add(
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                // 설정 버튼 클릭 시 동작
              },
              tooltip: '설정',
            ),
          );
          break;
      }
    } else {
      switch (type) {
        case AppBarType.feed:
          actions.add(
            TextButton(
              onPressed: onLoginTap,
              child: const Text(
                '로그인',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
          break;

        case AppBarType.record:
          actions.add(
            TextButton(
              onPressed: onLoginTap,
              child: const Text(
                '로그인 필요',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
          break;

        case AppBarType.myPage:
          actions.add(
            TextButton(
              onPressed: onLoginTap,
              child: const Text(
                '로그인',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
          break;
      }
    }

    return actions;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
