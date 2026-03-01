import 'dart:math';

import 'package:flutter/material.dart';

class ShakeWidget extends StatelessWidget {
  final Widget child;
  final AnimationController controller;

  const ShakeWidget({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // sine 곡선 이용한 흔들림 애니메이션 정의
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller);

    return AnimatedBuilder(
      animation: offsetAnimation,
      builder: (context, child) {
        // 사인파(sin)를 이용해 좌우(-1 ~ 1)로 흔드는 로직
        final double offset = sin(controller.value * pi * 4) * 10;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: child,
    );
  }
}
