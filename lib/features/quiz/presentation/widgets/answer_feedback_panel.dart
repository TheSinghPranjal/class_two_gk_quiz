import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/candy_button.dart';
import '../../../../core/widgets/mascot.dart';
import 'fun_fact_card.dart';

/// The correction panel shown after a wrong answer, with the correct
/// answer, a short explanation, and a Next button.
class AnswerFeedbackPanel extends StatelessWidget {
  final String correctAnswer;
  final String explanation;
  final VoidCallback onNext;

  const AnswerFeedbackPanel({
    super.key,
    required this.correctAnswer,
    required this.explanation,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + MediaQuery.paddingOf(context).bottom),
      decoration: BoxDecoration(
        color: AppColors.quizCream,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD9C29A).withValues(alpha: 0.55),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Mascot(mood: MascotMood.sad, size: 64),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Not quite!',
                      style: AppTextStyles.heading(fontSize: 24, color: AppColors.errorDark, weight: FontWeight.w800),
                    ),
                    Text('Correct answer', style: AppTextStyles.body(fontSize: 14, color: AppColors.inkMuted)),
                    Text(
                      correctAnswer,
                      style: AppTextStyles.heading(fontSize: 22, color: AppColors.successDark, weight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (explanation.isNotEmpty) ...[
            const SizedBox(height: 12),
            FunFactCard(funFact: explanation),
          ],
          const SizedBox(height: 18),
          CandyButton(
            width: double.infinity,
            color: AppColors.primary,
            onPressed: onNext,
            child: const Text('NEXT'),
          ),
        ],
      ),
    );
  }
}
