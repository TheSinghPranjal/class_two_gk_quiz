import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../repositories/question_repository.dart';
import '../../bookmarks/presentation/bookmarks_screen.dart';
import '../../history/presentation/history_screen.dart';
import '../../history/providers/history_provider.dart';
import '../../rapid_fire/presentation/rapid_fire_setup_screen.dart';
import '../../sections/presentation/section_detail_screen.dart';
import '../../sections/providers/sections_provider.dart';
import 'widgets/home_header.dart';
import 'widgets/rapid_fire_banner.dart';
import 'widgets/section_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionBank = ref.watch(questionBankProvider);
    if (!questionBank.hasValue) {
      return Scaffold(
        body: AnimatedBackground(
          child: Center(
            child: questionBank.hasError
                ? Text('Could not load questions.', style: AppTextStyles.heading(fontSize: 18, color: AppColors.inkDeep))
                : const CircularProgressIndicator(),
          ),
        ),
      );
    }

    final sections = ref.watch(sectionsProvider);
    final history = ref.watch(historyControllerProvider);
    final historyNotifier = ref.watch(historyControllerProvider.notifier);
    final questionRepo = ref.watch(questionRepositoryProvider);

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: HomeHeader(
                  totalAttempts: history.length,
                  onHistoryTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  ),
                  onBookmarksTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BookmarksScreen()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose Your Adventure',
                    style: AppTextStyles.heading(fontSize: 24, color: AppColors.inkDeep, weight: FontWeight.w800),
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isPhone = constraints.maxWidth < 600;
                    final crossAxisCount = isPhone
                        ? 2
                        : constraints.maxWidth < 1024
                        ? 3
                        : 4;
                    final items = <Widget>[
                      RapidFireBanner(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RapidFireSetupScreen(),
                          ),
                        ),
                      ),
                      for (var i = 0; i < sections.length; i++)
                        SectionCard(
                          index: i + 1,
                          section: sections[i],
                          questionCount: questionRepo.countForSection(
                            sections[i].id,
                          ),
                          bestScore: historyNotifier.bestScoreForSection(
                            sections[i].id,
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  SectionDetailScreen(section: sections[i]),
                            ),
                          ),
                        ),
                    ];
                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.86,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, i) => items[i],
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
