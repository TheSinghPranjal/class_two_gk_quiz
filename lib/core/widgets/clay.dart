import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// A soft, puffy "claymorphism" surface: a gentle top-to-bottom gradient, a
/// coloured drop shadow, plus inner highlight (top) and inner shade (bottom)
/// so it looks like a squishy piece of modelling clay.
class Clay extends StatelessWidget {
  const Clay({
    super.key,
    required this.color,
    this.child,
    this.width,
    this.height,
    this.borderRadius = 28,
    this.circle = false,
    this.depth = 1,
    this.padding,
  });

  final Color color;
  final Widget? child;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool circle;

  /// Multiplier for shadow strength; 0 flattens the surface (pressed state).
  final double depth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final radius = circle
        ? BorderRadius.circular(999)
        : BorderRadius.circular(borderRadius);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.lighten(color, 0.08), color],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darken(
              color,
              0.25,
            ).withValues(alpha: 0.45 * depth),
            blurRadius: 18 * depth,
            offset: Offset(0, 10 * depth),
          ),
          BoxShadow(
            color: AppColors.darken(color, 0.12).withValues(alpha: depth),
            offset: Offset(0, 4 * depth),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _ClayInnerPainter(radius: radius, color: color),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
  }
}

class _ClayInnerPainter extends CustomPainter {
  _ClayInnerPainter({required this.radius, required this.color});

  final BorderRadius radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = radius.resolve(TextDirection.ltr).toRRect(rect);
    canvas.save();
    canvas.clipRRect(rrect);
    final edge = (size.shortestSide * 0.12).clamp(4.0, 10.0);
    _inner(
      canvas,
      rect,
      rrect,
      Offset(0, edge),
      Colors.white.withValues(alpha: 0.65),
      edge,
    );
    _inner(
      canvas,
      rect,
      rrect,
      Offset(0, -edge),
      AppColors.darken(color, 0.15).withValues(alpha: 0.55),
      edge,
    );
    canvas.restore();
  }

  void _inner(
    Canvas canvas,
    Rect rect,
    RRect rrect,
    Offset shift,
    Color shade,
    double blur,
  ) {
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(blur * 4))
      ..addRRect(rrect.shift(shift));
    canvas.drawPath(
      path,
      Paint()
        ..color = shade
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur * 0.8),
    );
  }

  @override
  bool shouldRepaint(covariant _ClayInnerPainter old) =>
      old.color != color || old.radius != radius;
}

/// A [Clay] surface that squishes down when tapped.
class ClayButton extends StatefulWidget {
  const ClayButton({
    super.key,
    required this.color,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 28,
    this.circle = false,
    this.padding,
    this.semanticsLabel,
  });

  final Color color;
  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool circle;
  final EdgeInsetsGeometry? padding;
  final String? semanticsLabel;

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.onPressed != null;
    return Semantics(
      button: true,
      enabled: active,
      label: widget.semanticsLabel,
      child: GestureDetector(
        onTapDown: active ? (_) => _setPressed(true) : null,
        onTapUp: active
            ? (_) {
                _setPressed(false);
                HapticFeedback.lightImpact();
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: active ? () => _setPressed(false) : null,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: _pressed ? 0.35 : 1),
            duration: const Duration(milliseconds: 110),
            builder: (context, depth, child) => Clay(
              color: widget.color,
              width: widget.width,
              height: widget.height,
              borderRadius: widget.borderRadius,
              circle: widget.circle,
              depth: depth,
              padding: widget.padding,
              child: child,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
