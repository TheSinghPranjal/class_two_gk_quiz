import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/sections_data.dart';
import '../../../models/question.dart';
import '../../../models/quiz_config.dart';
import '../../../models/quiz_enums.dart';
import '../../../models/quiz_state.dart';
import '../../bookmarks/providers/bookmark_provider.dart';
import '../../results/presentation/results_screen.dart';
import '../../sections/presentation/section_visuals.dart';
import '../providers/quiz_controller.dart';
import 'widgets/answer_feedback_panel.dart';
import 'widgets/leave_quiz_dialog.dart';
import 'widgets/option_button.dart';
import 'widgets/pause_overlay.dart';
import 'widgets/score_badge.dart';
import 'widgets/timer_badge.dart';

const _optionLabels = ['A', 'B', 'C', 'D'];

// The scene artwork is 821px wide; overlay positions below are measured
// against it so they stay aligned at any screen width.
const _sceneWidth = 821.0;
const _sceneHeight = 580.0;
const _groundAspect = 218 / 821;

class QuizScreen extends ConsumerStatefulWidget {
  final QuizConfig config;

  const QuizScreen({super.key, required this.config});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> with WidgetsBindingObserver {
  bool _navigatedAway = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() => ref.read(quizControllerProvider.notifier).start(widget.config));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      ref.read(quizControllerProvider.notifier).pause();
    }
  }

  String _timeLabel(int seconds) {
    final isShort = widget.config.durationSeconds <= 60;
    if (isShort) return '${seconds}s';
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  void _handleBack() {
    final status = ref.read(quizControllerProvider).status;
    if (status == QuizStatus.paused) {
      _confirmExit();
    } else {
      ref.read(quizControllerProvider.notifier).pause();
    }
  }

  Future<void> _confirmExit() async {
    final confirmed = await showLeaveQuizDialog(context);
    if (confirmed) {
      ref.read(quizControllerProvider.notifier).exit();
    }
  }

  OptionVisualState _visualState(QuizState state, Question question, int index) {
    if (state.status == QuizStatus.showingAnswer) {
      if (index == question.correctAnswerIndex) return OptionVisualState.correctRevealed;
      if (index == state.selectedIndex) return OptionVisualState.wrongSelected;
      return OptionVisualState.disabled;
    }
    if (state.selectedIndex == index) return OptionVisualState.correctRevealed;
    return OptionVisualState.idle;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<QuizState>(
      quizControllerProvider,
      (previous, next) {
        if (_navigatedAway) return;
        if (next.status == QuizStatus.completed) {
          _navigatedAway = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => ResultsScreen(config: widget.config, state: next)),
          );
        } else if (next.status == QuizStatus.exited) {
          _navigatedAway = true;
          Navigator.of(context).pop();
        }
      },
    );

    final state = ref.watch(quizControllerProvider);
    final question = state.currentQuestion;
    final controller = ref.read(quizControllerProvider.notifier);
    final isShortFormat = widget.config.durationSeconds <= 60;
    final bookmarks = ref.watch(bookmarkControllerProvider);
    final width = MediaQuery.sizeOf(context).width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.quizCream,
        body: question == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.asset('assets/images/quiz/ground.png', fit: BoxFit.fitWidth),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: width * _groundAspect * 0.6),
                          child: Column(
                            children: [
                              _QuizScene(
                                title: widget.config.title,
                                emoji: sectionById(question.sectionId).emoji,
                                questionId: question.id,
                                remainingSeconds: state.remainingSeconds,
                                isShortFormat: isShortFormat,
                                score: state.score,
                                onBack: _handleBack,
                                onPause: controller.pause,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 19),
                                child: Column(
                                  children: [
                                    Transform.translate(
                                      offset: const Offset(0, -8),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 250),
                                        child: _QuestionCard(
                                          key: ValueKey(question.id),
                                          question: question.questionText,
                                          bookmarked: bookmarks.contains(question.id),
                                          onBookmark: () =>
                                              ref.read(bookmarkControllerProvider.notifier).toggle(question.id),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    for (var i = 0; i < question.options.length; i++)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 14),
                                        child: OptionButton(
                                          key: ValueKey('${question.id}-$i'),
                                          index: i,
                                          label: _optionLabels[i],
                                          text: question.options[i],
                                          visualState: _visualState(state, question, i),
                                          onTap: state.status == QuizStatus.playing
                                              ? () => controller.selectOption(i)
                                              : null,
                                        ),
                                      ),
                                    if (state.status == QuizStatus.playing) ...[
                                      const SizedBox(height: 4),
                                      _SkipPill(onTap: controller.skip),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (state.status == QuizStatus.showingAnswer)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnswerFeedbackPanel(
                        correctAnswer: question.correctAnswerText,
                        explanation: question.explanation,
                        onNext: controller.next,
                      ),
                    ),
                  if (state.status == QuizStatus.paused)
                    Positioned.fill(
                      child: PauseOverlay(
                        timeLabel: _timeLabel(state.remainingSeconds),
                        onResume: controller.resume,
                        onRestart: controller.restart,
                        onExit: _confirmExit,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

/// Painted header: hanging wooden sign with the quiz title, back and pause
/// buttons, timer and score chips, and the section's picture standing on
/// the grassy hill.
class _QuizScene extends StatelessWidget {
  const _QuizScene({
    required this.title,
    required this.emoji,
    required this.questionId,
    required this.remainingSeconds,
    required this.isShortFormat,
    required this.score,
    required this.onBack,
    required this.onPause,
  });

  final String title;
  final String emoji;
  final String questionId;
  final int remainingSeconds;
  final bool isShortFormat;
  final int score;
  final VoidCallback onBack;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final scale = width / _sceneWidth;
    final height = _sceneHeight * scale;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    Widget picture = Text(emoji, style: TextStyle(fontSize: 250 * scale, height: 1));
    if (!reduceMotion) {
      picture = picture
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(begin: 0, end: -6, duration: 1600.ms, curve: Curves.easeInOut);
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/quiz/scene.png', fit: BoxFit.fill)),
          Positioned(
            left: 230 * scale,
            right: (_sceneWidth - 592) * scale,
            top: 134 * scale,
            height: 74 * scale,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: AppTextStyles.heading(
                    fontSize: 28,
                    color: AppColors.woodInk,
                    weight: FontWeight.w800,
                  ).copyWith(
                    shadows: const [Shadow(color: Color(0x66FFE2B0), offset: Offset(0, 1.5))],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 34 * scale,
            top: 151 * scale,
            child: _SquareButton(
              size: 78 * scale,
              icon: Icons.arrow_back_ios_new_rounded,
              label: 'Back',
              onTap: onBack,
            ),
          ),
          Positioned(
            right: 34 * scale,
            top: 151 * scale,
            child: _SquareButton(
              size: 78 * scale,
              icon: Icons.pause_rounded,
              label: 'Pause',
              onTap: onPause,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 262 * scale,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimerBadge(remainingSeconds: remainingSeconds, isShortFormat: isShortFormat),
                const SizedBox(width: 10),
                ScoreBadge(score: score),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: (_sceneHeight - 552) * scale,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 20 * scale),
                child: picture,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.size,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final double size;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size * 0.3),
            border: Border.all(color: const Color(0xFFF5E1BC), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD9C29A).withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.inkDeep, size: size * 0.48),
        ),
      ),
    );
  }
}

/// White rounded card with the question text and a pink bookmark button.
class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    super.key,
    required this.question,
    required this.bookmarked,
    required this.onBookmark,
  });

  final String question;
  final bool bookmarked;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 77),
      padding: const EdgeInsets.fromLTRB(20, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD9C29A).withValues(alpha: 0.45),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
          const BoxShadow(color: Color(0xFFF1E6D3), offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          // Balances the bookmark so the text sits in the card's centre.
          const SizedBox(width: 30),
          Expanded(
            child: Text(
              question,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading(
                fontSize: 23,
                color: AppColors.inkDeep,
                weight: FontWeight.w800,
              ).copyWith(height: 1.25),
            ),
          ),
          const SizedBox(width: 10),
          Semantics(
            button: true,
            label: bookmarked ? 'Remove bookmark' : 'Bookmark',
            child: Material(
              color: const Color(0xFFFEE3EE),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onBookmark,
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    bookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: const Color(0xFFE91E7A),
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkipPill extends StatelessWidget {
  const _SkipPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF0D5),
            borderRadius: BorderRadius.circular(21),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE9D3AE).withValues(alpha: 0.5),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⏭️', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Text(
                'SKIP',
                style: AppTextStyles.heading(fontSize: 16, color: AppColors.hintInk, weight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
