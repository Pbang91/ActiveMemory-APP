import 'package:active_memory/src/common/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CommonMessageView extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryText;

  const CommonMessageView({
    super.key,
    required this.message,
    this.icon = Icons.info_outline, // 기본 아이콘
    this.onRetry,
    this.retryText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: AppColors.textSecondary.withOpacity(0.5), // 은은한 회색
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(retryText ?? "다시 시도"),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
