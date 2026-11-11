import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:class_two_qk_quiz/core/theme/app_colors.dart';
import 'package:class_two_qk_quiz/core/theme/app_theme.dart';
import 'package:class_two_qk_quiz/features/splash/presentation/splash_screen.dart';

void main() {
  const hold = Duration(minutes: 5);

  Future<void> pumpSplash(
    WidgetTester tester, {
    required Size size,
    ThemeData? theme,
    TextScaler textScaler = TextScaler.noScaling,
    bool disableAnimations = false,
    EdgeInsets viewPadding = EdgeInsets.zero,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.view.viewPadding = FakeViewPadding(
      left: viewPadding.left,
      top: viewPadding.top,
      right: viewPadding.right,
      bottom: viewPadding.bottom,
    );
    tester.view.padding = FakeViewPadding(
      left: viewPadding.left,
      top: viewPadding.top,
      right: viewPadding.right,
      bottom: viewPadding.bottom,
    );
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme ?? AppTheme.light,
        builder: (context, child) {
          final media = MediaQuery.of(context);
          return MediaQuery(
            data: media.copyWith(
              textScaler: textScaler,
              disableAnimations: disableAnimations,
            ),
            child: child!,
          );
        },
        home: const SplashScreen(duration: hold),
      ),
    );
    // Entrance motion uses a short delay. Elapse it so no timer is left pending.
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  }

  void expectBranding() {
    expect(find.text('Class 2 Quick Quiz'), findsOneWidget);
    expect(find.text('by'), findsOneWidget);
    expect(find.text('The Lazy Bear Club'), findsOneWidget);
    expect(find.byKey(const Key('lazyBearClubIcon')), findsOneWidget);
  }

  testWidgets('splash shows the app name and studio byline on a phone', (
    tester,
  ) async {
    await pumpSplash(
      tester,
      size: const Size(390, 844),
      viewPadding: const EdgeInsets.only(top: 47, bottom: 34),
    );
    expectBranding();

    final title = tester.widget<Text>(find.text('Class 2 Quick Quiz'));
    final byline = tester.widget<Text>(find.text('The Lazy Bear Club'));
    final by = tester.widget<Text>(find.text('by'));
    expect(
      ThemeData.estimateBrightnessForColor(title.style!.color!),
      Brightness.dark,
    );
    expect(title.style!.color, AppColors.inkDeep);
    expect(byline.style!.color, AppColors.inkDeep);
    expect(by.style!.color, AppColors.ink);
  });

  testWidgets('splash stays readable in a dark theme', (tester) async {
    await pumpSplash(
      tester,
      size: const Size(390, 844),
      theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
    );
    expectBranding();

    final title = tester.widget<Text>(find.text('Class 2 Quick Quiz'));
    final byline = tester.widget<Text>(find.text('The Lazy Bear Club'));
    expect(
      ThemeData.estimateBrightnessForColor(title.style!.color!),
      Brightness.light,
    );
    // The byline sits on a light clay card, so its ink stays dark.
    expect(
      ThemeData.estimateBrightnessForColor(byline.style!.color!),
      Brightness.dark,
    );
    expect(byline.style!.color, AppColors.inkDeep);
  });

  testWidgets('splash fits small phones, landscape, tablets, and large text', (
    tester,
  ) async {
    const cases = <Size>[
      Size(320, 568),
      Size(667, 375),
      Size(800, 1280),
      Size(1024, 768),
    ];

    for (final size in cases) {
      await pumpSplash(tester, size: size);
      expectBranding();
      await pumpSplash(
        tester,
        size: size,
        textScaler: const TextScaler.linear(2),
        disableAnimations: true,
      );
      expectBranding();
    }

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
