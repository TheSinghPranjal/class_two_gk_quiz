import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'clay.dart';

/// A round cream clay button used for back/utility actions in headers, so
/// touch targets stay large and consistent everywhere.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final String? tooltip;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.tooltip,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    final button = ClayButton(
      color: AppColors.clayCream,
      circle: true,
      width: size,
      height: size,
      semanticsLabel: tooltip,
      onPressed: onTap,
      child: Center(
        child: Icon(icon, color: color ?? AppColors.ink, size: size * 0.5),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
