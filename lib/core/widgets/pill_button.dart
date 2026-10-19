import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Glossy pill button with a darker "depth" edge that flattens when pressed.
/// Used in dialogs; [PillButton.soft] and [PillButton.strong] give the two
/// standard looks.
class PillButton extends StatefulWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.topColor,
    required this.bottomColor,
    required this.depthColor,
    required this.textColor,
    required this.onPressed,
  });

  const PillButton.soft({super.key, required this.label, required this.onPressed})
      : topColor = AppColors.keepPlayingTop,
        bottomColor = AppColors.keepPlayingBottom,
        depthColor = AppColors.keepPlayingDepth,
        textColor = AppColors.keepPlayingText;

  const PillButton.strong({super.key, required this.label, required this.onPressed})
      : topColor = AppColors.leaveTop,
        bottomColor = AppColors.leaveBottom,
        depthColor = AppColors.leaveDepth,
        textColor = AppColors.surface;

  final String label;
  final Color topColor;
  final Color bottomColor;
  final Color depthColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  static const double _height = 48;
  static const double _depth = 5;
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) {
          _setPressed(false);
          HapticFeedback.lightImpact();
          widget.onPressed();
        },
        onTapCancel: () => _setPressed(false),
        child: SizedBox(
          height: _height + _depth,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOut,
            margin: EdgeInsets.only(
              top: _pressed ? _depth : 0,
              bottom: _pressed ? 0 : _depth,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_height / 2),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [widget.topColor, widget.bottomColor],
              ),
              border: Border.all(
                color: AppColors.surface.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.depthColor,
                  offset: Offset(0, _pressed ? 0 : _depth),
                ),
                BoxShadow(
                  color: widget.depthColor.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: Offset(0, _pressed ? 2 : _depth + 4),
                ),
              ],
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.label,
                  style: AppTextStyles.button(
                    fontSize: 19,
                    color: widget.textColor,
                  ).copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
