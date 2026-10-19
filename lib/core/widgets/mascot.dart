import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';

enum MascotMood { idle, happy, cheering, sad, thinking }

/// The owl — the app's mascot. Built as a big friendly emoji inside a
/// styled circle with gentle idle animations, so the app works without
/// needing a bundled Lottie file.
class Mascot extends StatelessWidget {
  const Mascot({
    super.key,
    this.mood = MascotMood.idle,
    this.size = 120,
  });

  final MascotMood mood;
  final double size;

  String get _emoji => switch (mood) {
        MascotMood.idle => '🦉',
        MascotMood.happy => '🦉',
        MascotMood.cheering => '🥳',
        MascotMood.sad => '🦉',
        MascotMood.thinking => '🦉',
      };

  @override
  Widget build(BuildContext context) {
    final circle = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(_emoji, style: TextStyle(fontSize: size * 0.6)),
    );

    Widget animated = circle
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -8, duration: 1400.ms, curve: Curves.easeInOut);

    if (mood == MascotMood.cheering) {
      animated = animated
          .animate(onPlay: (c) => c.repeat())
          .rotate(begin: -0.03, end: 0.03, duration: 300.ms);
    }

    return animated;
  }
}

/// A rounded speech bubble, typically used with [Mascot] to show a friendly
/// line of dialogue.
class MascotSpeechBubble extends StatelessWidget {
  const MascotSpeechBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }
}
