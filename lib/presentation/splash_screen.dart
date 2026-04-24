import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_strings.dart';
import '../core/constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showMain = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(AppStyle.splashHold, () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showMain = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppStyle.pageCrossFade,
      child: _showMain
          ? MainScreen(
              themeMode: widget.themeMode,
              onThemeModeChanged: widget.onThemeModeChanged,
            )
          : const _KawaiiSplashContent(key: ValueKey<String>('kawaii-splash')),
    );
  }
}

class _KawaiiSplashContent extends StatelessWidget {
  const _KawaiiSplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onGradient = isDark ? Colors.white : const Color(0xFF2B132C);
    final gradient = isDark
        ? AppStyle.splashGradientDark
        : AppStyle.splashGradientLight;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: AppStyle.scaleIntroFrom, end: 1),
            duration: AppStyle.splashPopIn,
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.splashKaomoji,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: onGradient,
                  ),
                ),
                const SizedBox(height: AppStyle.splashAfterKaomoji),
                Text(
                  AppStrings.appTitle,
                  style: GoogleFonts.quicksand(
                    fontSize: AppStyle.splashTitleFontSize,
                    fontWeight: FontWeight.w700,
                    letterSpacing: AppStyle.splashTitleLetterSpacing,
                    color: onGradient,
                  ).copyWith(
                    fontFamilyFallback: AppFonts.baseFallback,
                  ),
                ),
                const SizedBox(height: AppStyle.spaceSm),
                Text(
                  l10n.splashSubtitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: onGradient,
                  ),
                ),
                const SizedBox(height: AppStyle.splashAfterSubtitle),
                Icon(
                  Icons.favorite,
                  size: AppStyle.splashHeartIconSize,
                  color: onGradient,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
