import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../core/widgets/clay.dart';

class HomeHeader extends StatelessWidget {
  final int totalAttempts;
  final VoidCallback onHistoryTap;
  final VoidCallback onBookmarksTap;

  const HomeHeader({
    super.key,
    required this.totalAttempts,
    required this.onHistoryTap,
    required this.onBookmarksTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Clay(
          color: AppColors.clayCream,
          circle: true,
          width: 58,
          height: 58,
          child: Center(child: Text('🦉', style: TextStyle(fontSize: 32))),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi Champ! 👋',
                style: AppTextStyles.heading(fontSize: 24, weight: FontWeight.w800),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                totalAttempts == 0 ? 'Ready to learn something fun?' : '$totalAttempts quizzes played so far!',
                style: AppTextStyles.body(fontSize: 13, color: AppColors.inkMuted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        AppIconButton(
          icon: Icons.bookmark_rounded,
          tooltip: 'Bookmarks',
          onTap: onBookmarksTap,
        ),
        const SizedBox(width: 6),
        AppIconButton(
          icon: Icons.history_rounded,
          tooltip: 'History',
          onTap: onHistoryTap,
        ),
      ],
    );
  }
}

