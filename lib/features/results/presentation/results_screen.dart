import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/scoring.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/candy_button.dart';
import '../../../core/widgets/clay.dart';
import '../../../core/widgets/mascot.dart';
import '../../../core/widgets/star_burst.dart';
import '../../../models/quiz_config.dart';
import '../../../models/quiz_state.dart';
import '../../quiz/presentation/quiz_screen.dart';

class ResultsScreen extends StatelessWidget {
  final QuizConfig config;
  final QuizState state;

  const ResultsScreen({super.key, required this.config, required this.state});

  String _message(double accuracy, int totalAnswered) {
    if (totalAnswered == 0) return "Give it a try — every question helps you learn!";
    if (accuracy >= 80) return 'Wonderful work! You really know this! 🌟';
    if (accuracy >= 50) return "Great effort! You're getting better! 💪";
    return 'Nice try! Practice makes perfect. 🌱';
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = state.totalAnswered == 0 ? 0.0 : (state.correctCount / state.totalAnswered) * 100;
    final elapsed = config.durationSeconds - state.remainingSeconds;
    final stars = starsForScore(state.correctCount, state.totalAnswered);

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Mascot(mood: stars > 0 ? MascotMood.cheering : MascotMood.sad, size: 120),
                const SizedBox(height: 16),
                Text('GREAT JOB!', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text(
                  _message(accuracy, state.totalAnswered),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                StarBurst(stars: stars, size: 48, animate: true),
                const SizedBox(height: 12),
                Text('You scored', style: AppTextStyles.body(color: AppColors.inkMuted)),
                Text(
                  '${state.score}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primaryDark, fontSize: 48),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.05,
                  children: [
                    _StatTile(emoji: '📝', label: 'Attempted', value: '${state.questionsSeen}'),
                    _StatTile(emoji: '✅', label: 'Correct', value: '${state.correctCount}'),
                    _StatTile(emoji: '❌', label: 'Wrong', value: '${state.wrongCount}'),
                    _StatTile(emoji: '⏭️', label: 'Skipped', value: '${state.skippedCount}'),
                    _StatTile(emoji: '🎯', label: 'Accuracy', value: '${accuracy.round()}%'),
                    _StatTile(
                      emoji: '⏱️',
                      label: 'Time Played',
                      value: config.durationSeconds <= 60 ? '${elapsed}s' : '${(elapsed / 60).toStringAsFixed(1)}m',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                CandyButton(
                  width: double.infinity,
                  color: AppColors.primary,
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => QuizScreen(config: config)),
                  ),
                  child: const Text('PLAY AGAIN'),
                ),
                const SizedBox(height: 14),
                CandyButton(
                  width: double.infinity,
                  color: AppColors.starDark,
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CHOOSE ANOTHER QUIZ'),
                ),
                const SizedBox(height: 14),
                CandyButton(
                  width: double.infinity,
                  color: AppColors.inkMuted,
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text('HOME'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _StatTile({required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Clay(
      color: AppColors.clayCream,
      borderRadius: 24,
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: AppTextStyles.heading(fontSize: 22, weight: FontWeight.w800)),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: AppTextStyles.body(fontSize: 12, color: AppColors.inkMuted)),
          ),
        ],
      ),
    );
  }
}
