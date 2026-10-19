import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A cream background with a few big, slowly floating pastel blobs. Purely
/// decorative — respects [MediaQuery.disableAnimations].
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key, this.child});

  final Widget? child;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          if (!reduceMotion)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => CustomPaint(
                  painter: _BlobPainter(_controller.value),
                ),
              ),
            ),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final blobs = AppColors.blobs;
    for (var i = 0; i < blobs.length; i++) {
      final paint = Paint()..color = blobs[i].withValues(alpha: 0.35);
      final phase = t * 2 * 3.14159 + i * 1.4;
      final dx = size.width * (0.2 + 0.6 * (i / blobs.length)) +
          20 * (i.isEven ? 1 : -1) * (0.5 + 0.5 * _wave(phase));
      final dy = size.height * (0.15 + 0.2 * i) +
          16 * _wave(phase + 1.0);
      final radius = size.width * (0.18 + 0.03 * i);
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  double _wave(double x) => (x - x.floorToDouble() - 0.5).abs() * 2 - 0.5;

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) => oldDelegate.t != t;
}
