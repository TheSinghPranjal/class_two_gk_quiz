import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/app_icon_button.dart';
import '../../../core/widgets/candy_button.dart';
import '../../../core/widgets/clay.dart';
import '../../../models/quiz_config.dart';
import '../../quiz/presentation/quiz_screen.dart';
import '../../sections/presentation/section_visuals.dart';
import '../../sections/providers/sections_provider.dart';
import '../providers/rapid_fire_setup_provider.dart';

class RapidFireSetupScreen extends ConsumerWidget {
  const RapidFireSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(sectionsProvider);
    final selected = ref.watch(rapidFireSetupProvider);
    final setupNotifier = ref.read(rapidFireSetupProvider.notifier);
    final isRandom = selected.isEmpty;

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Row(
                  children: [
                    AppIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Back',
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'Ready for Rapid Fire? ⚡',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading(fontSize: 30, color: AppColors.inkDeep, weight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Answer as many questions as you can in 30 seconds!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body(fontSize: 17, color: AppColors.inkMuted),
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Pick your sections',
                          style: AppTextStyles.heading(fontSize: 22, weight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SectionTile(
                        title: 'All Sections (Random)',
                        emoji: '🎲',
                        color: AppColors.primary,
                        selected: isRandom,
                        onTap: setupNotifier.selectRandom,
                        isCheckbox: false,
                        index: 0,
                      ),
                      const SizedBox(height: 12),
                      for (var i = 0; i < sections.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _SectionTile(
                            title: sections[i].title,
                            emoji: sections[i].emoji,
                            color: sections[i].color,
                            selected: !isRandom && selected.contains(sections[i].id),
                            onTap: () => setupNotifier.toggle(sections[i].id),
                            index: i + 1,
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: CandyButton(
                  width: double.infinity,
                  color: AppColors.modePractice,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        config: QuizConfig.rapidFire(sectionIds: selected.toList()),
                      ),
                    ),
                  ),
                  child: const Text('START RAPID FIRE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final String title;
  final String emoji;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final bool isCheckbox;
  final int index;

  const _SectionTile({
    required this.title,
    required this.emoji,
    required this.color,
    required this.selected,
    required this.onTap,
    required this.index,
    this.isCheckbox = true,
  });

  @override
  Widget build(BuildContext context) {
    final textShadow = [Shadow(color: AppColors.darken(color, 0.2), offset: const Offset(0, 2))];
    return ClayButton(
          color: selected ? color : AppColors.surface,
          width: double.infinity,
          borderRadius: 30,
          padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
          semanticsLabel: '$title${selected ? ', selected' : ''}',
          onPressed: onTap,
          child: Row(
            children: [
              Clay(
                color: AppColors.clayCream,
                circle: true,
                width: 48,
                height: 48,
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 26))),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.heading(
                    fontSize: 20,
                    color: selected ? Colors.white : AppColors.inkDeep,
                    weight: FontWeight.w800,
                  ).copyWith(shadows: selected ? textShadow : null),
                ),
              ),
              Icon(
                isCheckbox
                    ? (selected ? Icons.check_circle_rounded : Icons.circle_outlined)
                    : (selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded),
                color: selected ? Colors.white : AppColors.inkMuted,
                size: 30,
              ),
            ],
          ),
        )
        .animate(delay: (60 * index).ms)
        .fadeIn(duration: 300.ms)
        .moveY(begin: 16, end: 0, curve: Curves.easeOutBack);
  }
}
