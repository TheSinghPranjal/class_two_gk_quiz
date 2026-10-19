import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/pill_button.dart';

/// Asks whether to abandon the current quiz. Resolves to `true` when the
/// child chooses to leave.
Future<bool> showLeaveQuizDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: AppColors.inkDeep.withValues(alpha: 0.55),
    builder: (context) => const LeaveQuizDialog(),
  );
  return result ?? false;
}

class LeaveQuizDialog extends StatelessWidget {
  const LeaveQuizDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return OwlDialog(
      title: 'Leave this quiz?',
      body: 'Are you sure you want to leave this quiz?',
      actions: Row(
        children: [
          Expanded(
            flex: 8,
            child: PillButton.soft(
              label: 'CONTINUE PLAYING',
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 7,
            child: PillButton.strong(
              label: 'EXIT',
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cream dialog card with the owl on the left, a title and body text, and
/// a leaf tucked on the corner. Shared by the leave and pause dialogs.
class OwlDialog extends StatelessWidget {
  const OwlDialog({
    super.key,
    required this.title,
    required this.body,
    required this.actions,
    this.extra,
  });

  final String title;
  final String body;
  final Widget actions;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.dialogCream,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.inkDeep.withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/quiz/leave_owl.png',
                          width: 150,
                          excludeFromSemantics: true,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: AppTextStyles.heading(
                                    fontSize: 24,
                                    color: AppColors.inkDeep,
                                    weight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  body,
                                  style: AppTextStyles.body(
                                    fontSize: 15.5,
                                    color: AppColors.dialogBody,
                                  ).copyWith(height: 1.4),
                                ),
                                if (extra != null) ...[
                                  const SizedBox(height: 10),
                                  extra!,
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 2, 15, 15),
                    child: actions,
                  ),
                ],
              ),
            ),
            Positioned(
              top: -6,
              right: -4,
              child: Image.asset(
                'assets/images/quiz/leave_leaf.png',
                width: 45,
                excludeFromSemantics: true,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 150.ms)
        .scale(
          begin: const Offset(0.85, 0.85),
          duration: 280.ms,
          curve: Curves.easeOutBack,
        );
  }
}
