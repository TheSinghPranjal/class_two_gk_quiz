import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

enum OptionVisualState { idle, correctRevealed, wrongSelected, disabled }

const List<Color> kOptionPastels = [
  Color(0xFFFEC2DB), // A - pink
  Color(0xFFBDDAFD), // B - blue
  Color(0xFFFED968), // C - yellow
  Color(0xFFC4F7CA), // D - green
];

/// Darker rim along the bottom of each pastel, giving the card its 3D lip.
const List<Color> _optionRims = [
  Color(0xFFFC90B9),
  Color(0xFF92BCFB),
  Color(0xFFF7BE3A),
  Color(0xFF9DE1AD),
];

class OptionButton extends StatefulWidget {
  final int index;
  final String label;
  final String text;
  final OptionVisualState visualState;
  final VoidCallback? onTap;

  const OptionButton({
    super.key,
    required this.index,
    required this.label,
    required this.text,
    required this.visualState,
    required this.onTap,
  });

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton> {
  bool _pressed = false;

  int get _slot => widget.index % kOptionPastels.length;

  Color get _backgroundColor => switch (widget.visualState) {
        OptionVisualState.correctRevealed => AppColors.success,
        OptionVisualState.wrongSelected => AppColors.error,
        _ => kOptionPastels[_slot],
      };

  Color get _textColor => switch (widget.visualState) {
        OptionVisualState.correctRevealed || OptionVisualState.wrongSelected => Colors.white,
        _ => AppColors.inkDeep,
      };

  Color get _rimColor => switch (widget.visualState) {
        OptionVisualState.correctRevealed => AppColors.successDark,
        OptionVisualState.wrongSelected => AppColors.errorDark,
        _ => _optionRims[_slot],
      };

  bool get _tappable => widget.onTap != null && widget.visualState == OptionVisualState.idle;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.visualState;

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      constraints: const BoxConstraints(minHeight: 67),
      padding: const EdgeInsets.fromLTRB(15, 8, 16, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.lighten(_backgroundColor, 0.04), _backgroundColor],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: _rimColor.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(color: _rimColor, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFF5FA).withValues(alpha: 0.95),
              boxShadow: [
                BoxShadow(
                  color: _rimColor.withValues(alpha: 0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              widget.label,
              style: AppTextStyles.heading(
                fontSize: 21,
                color: AppColors.inkDeep,
                weight: FontWeight.w800,
              ).copyWith(height: 1),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              widget.text,
              style: AppTextStyles.heading(
                fontSize: 22,
                color: _textColor,
                weight: FontWeight.w700,
              ),
            ),
          ),
          if (state == OptionVisualState.correctRevealed)
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 32),
          if (state == OptionVisualState.wrongSelected)
            const Icon(Icons.cancel_rounded, color: Colors.white, size: 32),
        ],
      ),
    );

    if (state == OptionVisualState.correctRevealed) {
      content = content
          .animate()
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.04, 1.04),
            curve: Curves.elasticOut,
            duration: 400.ms,
          )
          .then()
          .scale(end: const Offset(1, 1));
    } else if (state == OptionVisualState.wrongSelected) {
      content = content.animate().shake(hz: 5, duration: 400.ms);
    }

    return Semantics(
      button: true,
      enabled: _tappable,
      label: '${widget.label}. ${widget.text}',
      child: GestureDetector(
        onTapDown: _tappable ? (_) => _setPressed(true) : null,
        onTapCancel: _tappable ? () => _setPressed(false) : null,
        onTapUp: _tappable
            ? (_) {
                _setPressed(false);
                HapticFeedback.lightImpact();
                widget.onTap?.call();
              }
            : null,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: _pressed ? 0.95 : 1.0,
          child: content,
        ),
      ),
    );
  }
}
