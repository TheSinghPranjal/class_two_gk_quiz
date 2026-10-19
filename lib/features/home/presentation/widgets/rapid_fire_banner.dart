import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import 'clay_tile.dart';

/// The high-energy "Rapid Fire" tile at the top of the home grid.
class RapidFireBanner extends StatelessWidget {
  final VoidCallback onTap;

  const RapidFireBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClayTile(
          color: AppColors.modePractice,
          title: 'Rapid Fire',
          icon: const Text('⚡'),
          semanticsLabel: 'Rapid Fire. 30 seconds, as many as you can',
          onTap: onTap,
        )
        .animate()
        .fadeIn(duration: 350.ms)
        .scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }
}
