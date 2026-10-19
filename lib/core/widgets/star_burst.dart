import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';

/// Renders 0-3 stars, filling in one at a time with a little pop and
/// sparkle. Used on section cards and the results screen.
class StarBurst extends StatelessWidget {
  const StarBurst({
    super.key,
    required this.stars,
    this.size = 28,
    this.animate = false,
  });

  final int stars;
  final double size;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final filled = i < stars;
        Widget star = Icon(
          filled ? Icons.star_rounded : Icons.star_border_rounded,
          color: filled ? AppColors.star : AppColors.inkMuted.withValues(alpha: 0.4),
          size: size,
        );
        if (animate && filled) {
          star = star
              .animate(delay: (i * 260).ms)
              .scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                curve: Curves.elasticOut,
                duration: 600.ms,
              )
              .then()
              .shimmer(duration: 500.ms, color: Colors.white);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: star,
        );
      }),
    );
  }
}
