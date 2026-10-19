import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/clay.dart';

/// A big squishy clay tile for the home grid: a large icon with little
/// sparkle strokes around it, a bold title and a row of embossed stars.
class ClayTile extends StatelessWidget {
  const ClayTile({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.onTap,
    this.stars = 0,
    this.progress = 0,
    this.semanticsLabel,
  });

  final Color color;
  final Widget icon;
  final String title;
  final VoidCallback onTap;
  final int stars;

  /// 0..1 mastery; a slim bar is shown once there's any progress.
  final double progress;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final shade = AppColors.darken(color, 0.1);

    return ClayButton(
      color: color,
      borderRadius: 36,
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      semanticsLabel: semanticsLabel ?? title,
      onPressed: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final iconSize = (constraints.maxHeight * 0.38).clamp(36.0, 84.0);
          return Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Positioned(
                      left: 6,
                      top: 18,
                      child: _Dash(angle: -0.6),
                    ),
                    const Positioned(
                      left: 2,
                      bottom: 22,
                      child: _Dash(angle: 0.3),
                    ),
                    const Positioned(
                      right: 6,
                      top: 18,
                      child: _Dash(angle: 0.6),
                    ),
                    const Positioned(
                      right: 2,
                      bottom: 22,
                      child: _Dash(angle: -0.3),
                    ),
                    DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: iconSize,
                        shadows: [
                          Shadow(
                            color: AppColors.darken(
                              color,
                              0.25,
                            ).withValues(alpha: 0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: icon,
                    ),
                  ],
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style:
                      AppTextStyles.heading(
                        fontSize: 21,
                        color: Colors.white,
                        weight: FontWeight.w800,
                      ).copyWith(
                        shadows: [
                          Shadow(
                            color: AppColors.darken(color, 0.22),
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final filled = i < stars;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      Icons.star_rounded,
                      size: 26,
                      color: filled ? AppColors.star : shade,
                      shadows: [
                        Shadow(
                          color: filled
                              ? AppColors.starDark
                              : Colors.white.withValues(alpha: 0.35),
                          offset: Offset(0, filled ? 2 : 1),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              if (progress > 0) ...[
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 70,
                    height: 6,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: shade,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Small yellow "shine" stroke decorating the tile icon.
class _Dash extends StatelessWidget {
  const _Dash({required this.angle});

  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 16,
        height: 7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.lighten(AppColors.star, 0.1), AppColors.star],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.starDark.withValues(alpha: 0.5),
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
