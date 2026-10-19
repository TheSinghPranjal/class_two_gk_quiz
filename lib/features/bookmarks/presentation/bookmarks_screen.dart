import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/clay.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../data/sections_data.dart';
import '../../../repositories/question_repository.dart';
import '../../sections/presentation/section_visuals.dart';
import '../providers/bookmark_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedIds = ref.watch(bookmarkControllerProvider);
    final repo = ref.watch(questionRepositoryProvider);
    final resolved = bookmarkedIds.map(repo.findById).where((q) => q != null).map((q) => q!).toList();

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              const ScreenHeader(title: 'Bookmarked Questions'),
              Expanded(
                child: resolved.isEmpty
                    ? const EmptyState(
                        emoji: '⭐',
                        title: 'No bookmarks yet!',
                        body: 'Tap the bookmark icon on any question during a quiz to save it here.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: resolved.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final q = resolved[index];
                          final section = sectionById(q.sectionId);
                          return Clay(
                            color: AppColors.surface,
                            borderRadius: 28,
                            padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Clay(
                                      color: section.color,
                                      borderRadius: 16,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      child: Text(
                                        '${section.emoji} ${section.title}',
                                        style: AppTextStyles.heading(
                                          fontSize: 14,
                                          color: Colors.white,
                                          weight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      tooltip: 'Remove bookmark',
                                      onPressed: () => ref.read(bookmarkControllerProvider.notifier).toggle(q.id),
                                      icon: const Icon(Icons.bookmark_rounded, color: Color(0xFFE91E7A)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  q.questionText,
                                  style: AppTextStyles.heading(fontSize: 19, color: AppColors.inkDeep, weight: FontWeight.w800),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        q.correctAnswerText,
                                        style: AppTextStyles.heading(
                                          fontSize: 17,
                                          color: AppColors.successDark,
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
