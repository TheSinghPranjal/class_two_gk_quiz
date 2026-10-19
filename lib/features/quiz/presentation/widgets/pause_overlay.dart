import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/clay.dart';
import '../../../../core/widgets/pill_button.dart';
import 'leave_quiz_dialog.dart';

class PauseOverlay extends StatelessWidget {
  final String timeLabel;
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const PauseOverlay({
    super.key,
    required this.timeLabel,
    required this.onResume,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.inkDeep.withValues(alpha: 0.55),
      alignment: Alignment.center,
      child: OwlDialog(
        title: 'PAUSED',
        body: 'Your progress is safe.',
        extra: Clay(
          color: AppColors.clayCream,
          borderRadius: 18,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            'Time remaining: $timeLabel',
            style: AppTextStyles.heading(fontSize: 17, weight: FontWeight.w800),
          ),
        ),
        actions: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: PillButton.soft(label: 'RESTART', onPressed: onRestart),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 8,
                  child: PillButton.strong(label: 'RESUME', onPressed: onResume),
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: onExit,
              child: Text(
                'EXIT QUIZ',
                style: AppTextStyles.button(fontSize: 17, color: AppColors.keepPlayingText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
