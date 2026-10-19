import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/utils/scoring.dart';
import '../../../../models/quiz_section.dart';
import '../../../sections/presentation/section_visuals.dart';
import 'clay_tile.dart';

class SectionCard extends StatefulWidget {
  final QuizSection section;
  final int questionCount;
  final int? bestScore;
  final VoidCallback onTap;
  final int index;

  const SectionCard({
    super.key,
    required this.section,
    required this.questionCount,
    required this.bestScore,
    required this.onTap,
    this.index = 0,
  });

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wobble;

  @override
  void initState() {
    super.initState();
    _wobble = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _wobble.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final best = widget.bestScore ?? 0;
    final total = widget.questionCount;
    final stars = starsForScore(best, total);
    final progress = total == 0 ? 0.0 : (best / total).clamp(0.0, 1.0);

    return AnimatedBuilder(
          animation: _wobble,
          builder: (context, child) {
            final wobble = (1 - _wobble.value) * _wobble.value * 4;
            return Transform.rotate(angle: wobble * 0.05, child: child);
          },
          child: ClayTile(
            color: widget.section.color,
            title: widget.section.title,
            stars: stars,
            progress: progress,
            semanticsLabel:
                '${widget.section.title}, $total questions, best $best, '
                '$stars stars',
            onTap: () {
              _wobble.forward(from: 0);
              widget.onTap();
            },
            icon: Hero(
              tag: 'section-emoji-${widget.section.id}',
              child: Text(widget.section.emoji),
            ),
          ),
        )
        .animate(delay: (60 * widget.index).ms)
        .fadeIn(duration: 350.ms)
        .scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }
}
