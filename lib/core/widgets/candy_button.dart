import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A big, chunky, rounded button with a 3D "candy" look: a darker bottom
/// shadow that shrinks to zero when pressed, so the button looks like it
/// pushes down into the page.
class CandyButton extends StatefulWidget {
  const CandyButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color = AppColors.primary,
    this.width,
    this.height = 64,
    this.borderRadius = 24,
    this.semanticsLabel,
    this.enabled = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color color;
  final double? width;
  final double height;
  final double borderRadius;
  final String? semanticsLabel;
  final bool enabled;

  @override
  State<CandyButton> createState() => _CandyButtonState();
}

class _CandyButtonState extends State<CandyButton> {
  bool _pressed = false;
  static const double _shadowDepth = 6;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && widget.onPressed != null;
    final baseColor = active ? widget.color : AppColors.inkMuted.withValues(alpha: 0.35);
    final shadowColor = AppColors.darken(widget.color);

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          width: widget.width,
          height: widget.height,
          margin: EdgeInsets.only(top: _pressed ? _shadowDepth : 0),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                offset: Offset(0, _pressed ? 0 : _shadowDepth),
              ),
            ],
          ),
          child: DefaultTextStyle(
            style: AppTextStyles.button(),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
