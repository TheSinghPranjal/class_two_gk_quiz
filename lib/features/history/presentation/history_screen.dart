import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/clay.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../data/sections_data.dart';
import '../../../models/quiz_enums.dart';
import '../../../models/quiz_result.dart';
import '../../sections/presentation/section_visuals.dart';
import '../providers/history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  String _timeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyControllerProvider);

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              const ScreenHeader(title: 'Your Quiz History'),
              Expanded(
                child: history.isEmpty
                    ? const EmptyState(
                        emoji: '📈',
                        title: 'No quizzes yet!',
                        body: 'Play a quiz and your attempts will show up here.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: history.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) =>
                            _HistoryCard(result: history[index], timeAgo: _timeAgo(history[index].timestamp)),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final QuizResult result;
  final String timeAgo;

  const _HistoryCard({required this.result, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    final isRapidFire = result.mode == QuizMode.rapidFire;
    final sectionLabel = result.sectionIds.isEmpty
        ? 'All Sections'
        : result.sectionIds.map((id) => sectionById(id).title).join(', ');
    final singleSection = result.sectionIds.length == 1 ? sectionById(result.sectionIds.first) : null;
    final emoji = isRapidFire ? '⚡' : (singleSection?.emoji ?? '📚');
    final color = isRapidFire ? AppColors.modePractice : (singleSection?.color ?? AppColors.primary);

    return Clay(
      color: AppColors.surface,
      borderRadius: 28,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Clay(
            color: color,
            circle: true,
            width: 52,
            height: 52,
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRapidFire ? 'Rapid Fire' : sectionLabel,
                  style: AppTextStyles.heading(fontSize: 19, color: AppColors.inkDeep, weight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  '${result.score} pts · ${result.totalAnswered} answered · ${result.accuracy.round()}% accuracy',
                  style: AppTextStyles.body(fontSize: 13, color: AppColors.inkMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(timeAgo, style: AppTextStyles.body(fontSize: 12, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}
