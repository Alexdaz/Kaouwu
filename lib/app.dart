import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_strings.dart';
import 'core/constants/app_constants.dart';
import 'l10n/app_localizations.dart';
import 'presentation/splash_screen.dart';

class KaouwuApp extends StatefulWidget {
  const KaouwuApp({super.key});

  @override
  State<KaouwuApp> createState() => _KaouwuAppState();
}

class _KaouwuAppState extends State<KaouwuApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(StorageKeys.themeMode);
    if (raw == null || !mounted) {
      return;
    }
    setState(() {
      _themeMode = _themeModeFromStorage(raw);
    });
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }
    setState(() {
      _themeMode = mode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.themeMode, _themeModeToStorage(mode));
  }

  String _themeModeToStorage(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _themeModeFromStorage(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  AppBarTheme _appBarTheme(ColorScheme scheme) {
    return AppBarTheme(
      centerTitle: true,
      titleTextStyle: GoogleFonts.quicksand(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: AppStyle.appBarTitleLetterSpacing,
        color: scheme.onSurface,
      ).copyWith(
        fontFamilyFallback: AppFonts.baseFallback,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const lightScheme = AppPalette.lightScheme;
    const darkScheme = AppPalette.darkScheme;

    return MaterialApp(
      title: AppStrings.materialAppTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        fontFamilyFallback: AppFonts.baseFallback,
        appBarTheme: _appBarTheme(lightScheme).copyWith(
          backgroundColor: AppPalette.lightAppBarBackground,
          foregroundColor: AppPalette.lightAppBarForeground,
        ),
        scaffoldBackgroundColor: AppPalette.lightScaffoldBackground,
        cardTheme: const CardThemeData(
          color: AppPalette.lightCardBackground,
          elevation: 1,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppPalette.lightNavigationBarBackground,
          indicatorColor: lightScheme.primaryContainer,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected ? lightScheme.primary : lightScheme.onSurfaceVariant,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              color: selected ? lightScheme.primary : lightScheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            );
          }),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: AppPalette.lightTabSelected,
          unselectedLabelColor: AppPalette.lightTabUnselected,
          indicatorColor: AppPalette.lightTabSelected,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          ThemeData(useMaterial3: true, colorScheme: lightScheme).textTheme,
        ).apply(
          fontFamilyFallback: AppFonts.baseFallback,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        fontFamilyFallback: AppFonts.baseFallback,
        appBarTheme: _appBarTheme(darkScheme).copyWith(
          backgroundColor: AppPalette.darkAppBarBackground,
          foregroundColor: AppPalette.darkAppBarForeground,
        ),
        scaffoldBackgroundColor: AppPalette.darkScaffoldBackground,
        cardTheme: const CardThemeData(
          color: AppPalette.darkCardBackground,
          elevation: 1,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppPalette.darkNavigationBarBackground,
          indicatorColor: darkScheme.primaryContainer,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected ? darkScheme.primary : darkScheme.onSurfaceVariant,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              color: selected ? darkScheme.primary : darkScheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            );
          }),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: AppPalette.darkTabSelected,
          unselectedLabelColor: AppPalette.darkTabUnselected,
          indicatorColor: AppPalette.darkTabSelected,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          ThemeData(useMaterial3: true, colorScheme: darkScheme).textTheme,
        ).apply(
          fontFamilyFallback: AppFonts.baseFallback,
        ),
      ),
      home: SplashScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
    );
  }
}
