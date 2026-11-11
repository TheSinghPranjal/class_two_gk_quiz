import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/clay.dart';
import '../../../core/widgets/mascot.dart';
import '../../home/presentation/home_screen.dart';

/// Official Lazy Bear Club mark, shown only on the splash byline.
const lazyBearClubAsset = 'assets/branding/lazy_bear_club.png';

const Color _darkBackground = Color(0xFF241C16);
const Color _darkTitle = Color(0xFFFFF6E8);
const Color _darkMuted = Color(0xFFE7D5C3);

/// Short in-app splash. The cream scene matches the rest of the quiz, then
/// fades into [HomeScreen].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.duration = displayDuration});

  /// How long the splash stays up before the home screen.
  static const Duration displayDuration = Duration(milliseconds: 2000);

  final Duration duration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  var _precached = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _timer = Timer(widget.duration, _openHome);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;
    precacheImage(const AssetImage(lazyBearClubAsset), context);
  }

  void _openHome() {
    if (!mounted) return;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionDuration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 350),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: dark ? _darkBackground : AppColors.background,
        body: _SplashBackdrop(
          dark: dark,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact =
                      constraints.maxHeight < 560 || constraints.maxWidth < 360;
                  final wide =
                      constraints.maxWidth >= 700 &&
                      constraints.maxHeight >= 700;
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 8),
                          _entrance(
                            context,
                            _SplashHero(compact: compact, wide: wide),
                          ),
                          _entrance(
                            context,
                            const Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 16),
                              child: _StudioByline(),
                            ),
                            delayMs: 120,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _entrance(BuildContext context, Widget child, {int delayMs = 0}) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return child
        .animate(delay: delayMs.ms)
        .fadeIn(duration: 450.ms, curve: Curves.easeOut)
        .slideY(begin: 0.08, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }
}

class _SplashBackdrop extends StatelessWidget {
  const _SplashBackdrop({required this.dark, required this.child});

  final bool dark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!dark) return AnimatedBackground(child: child);
    return ColoredBox(
      color: _darkBackground,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(top: -50, right: -40, child: _NightBlob(size: 200)),
          const Positioned(bottom: 60, left: -50, child: _NightBlob(size: 220)),
          child,
        ],
      ),
    );
  }
}

class _NightBlob extends StatelessWidget {
  const _NightBlob({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: 0.16),
        ),
      ),
    );
  }
}

class _SplashHero extends StatelessWidget {
  const _SplashHero({required this.compact, required this.wide});

  final bool compact;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final titleSize = wide
        ? 56.0
        : compact
        ? 34.0
        : 44.0;
    final mascotSize = wide
        ? 156.0
        : compact
        ? 96.0
        : 132.0;
    final titleColor = dark ? _darkTitle : AppColors.inkDeep;
    final subtitleColor = dark ? _darkMuted : AppColors.inkMuted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Mascot(size: mascotSize),
        SizedBox(height: compact ? 12 : 18),
        Text(
          'Class 2 Quick Quiz',
          textAlign: TextAlign.center,
          style: AppTextStyles.heading(
            fontSize: titleSize,
            color: titleColor,
            weight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ready to learn something fun?',
          textAlign: TextAlign.center,
          style: AppTextStyles.body(
            fontSize: compact ? 15 : 17,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }
}

class _StudioByline extends StatelessWidget {
  const _StudioByline();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Clay(
          color: AppColors.surface,
          borderRadius: 32,
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final available = constraints.maxWidth;
              final iconSize = (available.isFinite ? available : 76.0)
                  .clamp(0.0, 76.0)
                  .toDouble();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: Image.asset(
                      lazyBearClubAsset,
                      key: const Key('lazyBearClubIcon'),
                      width: iconSize,
                      height: iconSize,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'by',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body(
                        fontSize: 15,
                        color: AppColors.ink,
                        weight: FontWeight.w800,
                      ).copyWith(letterSpacing: 1.4),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'The Lazy Bear Club',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading(
                        fontSize: 22,
                        color: AppColors.inkDeep,
                        weight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
