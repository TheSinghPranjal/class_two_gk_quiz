import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/clay.dart';

/// Shows the remaining time with escalating visual urgency as it runs low.
/// Rapid Fire (<=60s total) renders as "24s"; longer quizzes render as
/// "04:32".
class TimerBadge extends StatefulWidget {
  final int remainingSeconds;
  final bool isShortFormat;

  const TimerBadge({super.key, required this.remainingSeconds, required this.isShortFormat});

  @override
  State<TimerBadge> createState() => _TimerBadgeState();
}

class _TimerBadgeState extends State<TimerBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urgent = widget.remainingSeconds <= 5 && widget.remainingSeconds > 0;
    final warning = widget.remainingSeconds <= 10 && !urgent;

    final color = urgent ? AppColors.error : (warning ? AppColors.modeQuiz : AppColors.clayCream);
    final textColor = urgent || warning ? Colors.white : AppColors.inkDeep;
    final label = widget.isShortFormat
        ? '${widget.remainingSeconds}s'
        : '${(widget.remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(widget.remainingSeconds % 60).toString().padLeft(2, '0')}';

    final badge = Clay(
      color: color,
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⏱️', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.heading(fontSize: 18, color: textColor, weight: FontWeight.w800)),
        ],
      ),
    );

    if (!urgent) return badge;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.08);
        return Transform.scale(scale: scale, child: child);
      },
      child: badge,
    );
  }
}
