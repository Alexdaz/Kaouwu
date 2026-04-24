import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Persistence and asset paths (storage keys and routes; keep separate from pixels and colors).

abstract final class StorageKeys {
  static const savedKaomojis = 'saved_kaomojis';
  static const favoriteKaomojis = 'favorite_kaomojis';
  static const skinToneIndex = 'skin_tone_index';
  static const themeMode = 'theme_mode';
}

abstract final class AssetPaths {
  static const kaomojisCatalog = 'assets/data/kaomojis.json';
  static const creatorParts = 'assets/data/creator_parts.json';
}

// Typography: symbol and script coverage (Noto, SIL OFL 1.1). Full text: assets/fonts/Noto-OFL.txt

abstract final class AppFonts {
  /// Japanese UI font (bundled). For kaomoji strings prefer [kaomojiDisplayFontFamily].
  static const String kaomojiFontFamily = 'Noto Sans JP';

  /// Pan-Unicode font for kaomoji tiles and previews. Covers Thai, combining marks on symbols,
  /// and CJK punctuation better than the app UI font (Nunito). Only Regular is bundled; avoid
  /// bold weights here or Flutter may synthesize bold and break combining mark placement.
  static const String kaomojiDisplayFontFamily = 'Noto Sans';

  /// After [kaomojiDisplayFontFamily]: bundled Noto families, then Android UI font for scripts
  /// missing from the small bundled Noto Sans (e.g. Thai with bullet in `(•ิ_•ิ)?`).
  static List<String> get kaomojiDisplayFallback => [
        'Noto Color Emoji',
        'Noto Sans Symbols 2',
        'Noto Sans Symbols',
        'Noto Sans JP',
        'Noto Sans Batak',
        'Noto Sans Brahmi',
        'Noto Serif Tibetan',
        'Noto Sans Egyptian Hieroglyphs',
        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
          'sans-serif',
      ];

  /// Primary fallback stack: avoids monochrome symbols overriding color emoji.
  static const List<String> baseFallback = [
    'Noto Color Emoji',
    'Noto Sans',
    'Noto Serif Tibetan',
    'Noto Sans Egyptian Hieroglyphs',
  ];

  /// Wider fallback for decorative strings with uncommon symbols.
  static const List<String> decorationFallback = [
    'Noto Color Emoji',
    'Noto Sans Symbols 2',
    'Noto Sans Symbols',
    'Noto Sans Batak',
    'Noto Sans Brahmi',
    'Noto Sans',
    'Noto Serif Tibetan',
    'Noto Sans Egyptian Hieroglyphs',
  ];
}

// App styling: shared timings, spacing, branding, and grid in one place.

/// Reused visual and timing values so widgets avoid magic numbers without one const per pixel.
abstract final class AppStyle {
  // Timing
  static const splashHold = Duration(milliseconds: 1900);
  static const pageCrossFade = Duration(milliseconds: 500);
  static const splashPopIn = Duration(milliseconds: 900);
  static const previewPulse = Duration(milliseconds: 220);
  static const tapFeedback = Duration(milliseconds: 120);

  /// Widget tests: allow splash and page transition (see [splashHold]).
  static const widgetTestWarmup = Duration(milliseconds: 2600);

  // Spacing (compact set; most screens use only these)
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;

  /// Tight vertical gap (e.g. title and body inside a card).
  static const double spaceCompact = 10;
  static const double spaceLg = 16;
  static const double spaceXl = 20;
  static const double spaceXxl = 24;

  /// Typical horizontal padding for screens and lists.
  static const double pagePadding = spaceLg;

  /// Text inset inside the compact square kaomoji card.
  static const double kaomojiCardInset = 6;

  /// Vertical gaps on the splash screen (title, subtitle, icon).
  static const double splashAfterKaomoji = 14;
  static const double splashAfterSubtitle = 22;

  // Scale (animations)
  static const double scaleIntroFrom = 0.9;
  static const double scalePressed = 0.95;
  static const scaleEmphasis = 1.03;

  // Typography and specific icon sizes
  static const double appBarTitleLetterSpacing = 0.6;
  static const double splashTitleFontSize = 44;
  static const double splashTitleLetterSpacing = 1;
  static const double kaomojiTileFontSize = 22;
  static const double badgeIconSize = 14;
  static const double splashHeartIconSize = 34;

  // Brand colors
  static const seed = Color(0xFFECA7CE);
  static const splashGradientDark = [
    Color(0xFF24131C),
    Color(0xFF2A1620),
    Color(0xFF3A2531),
  ];
  static const splashGradientLight = [
    Color(0xFFFFD3E8),
    Color(0xFFFFC1DF),
    Color(0xFFF7B6D2),
  ];

  // Kaomoji grid
  static const int gridColumns = 3;
  static const double gridSpacing = 10;
  static const double gridPadding = 12;
  static const double gridTileAspectRatio = 1;
}

/// Centralized palettes so themes avoid scattered magic colors.
abstract final class AppPalette {
  static const lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFE882AE),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFD3E4),
    onPrimaryContainer: Color(0xFF3D1328),
    secondary: Color(0xFFFFA3C3),
    onSecondary: Color(0xFF3D1328),
    secondaryContainer: Color(0xFFFFDCE8),
    onSecondaryContainer: Color(0xFF3D1328),
    tertiary: Color(0xFFFFB6CF),
    onTertiary: Color(0xFF3D1328),
    tertiaryContainer: Color(0xFFFFDFEA),
    onTertiaryContainer: Color(0xFF3D1328),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFF6EDF2),
    onSurface: Color(0xFF2F1C26),
    surfaceContainerHighest: Color(0xFFE8DDE3),
    onSurfaceVariant: Color(0xFF6A5862),
    outline: Color(0xFF8A737E),
    outlineVariant: Color(0xFFCDBFC6),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF35212B),
    onInverseSurface: Color(0xFFFDEFF6),
    inversePrimary: Color(0xFFFFB4D0),
  );

  static const darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFF8FBC),
    onPrimary: Color(0xFF3A1328),
    primaryContainer: Color(0xFF4A2538),
    onPrimaryContainer: Color(0xFFFFD7E6),
    secondary: Color(0xFFFF7AAE),
    onSecondary: Color(0xFF3A1328),
    secondaryContainer: Color(0xFF5A2D44),
    onSecondaryContainer: Color(0xFFFFD8E7),
    tertiary: Color(0xFFFFB0CC),
    onTertiary: Color(0xFF3A1328),
    tertiaryContainer: Color(0xFF6A3651),
    onTertiaryContainer: Color(0xFFFFDFEB),
    error: Color(0xFFFF5C67),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFF7D2430),
    onErrorContainer: Color(0xFFFFDAD9),
    surface: Color(0xFF2A1620),
    onSurface: Color(0xFFFBEAF1),
    surfaceContainerHighest: Color(0xFF4A2D3A),
    onSurfaceVariant: Color(0xFFE3C7D4),
    outline: Color(0xFFB58DA1),
    outlineVariant: Color(0xFF745360),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFFBEAF1),
    onInverseSurface: Color(0xFF2A1620),
    inversePrimary: Color(0xFF9B4A70),
  );

  // Light
  static const lightAppBarBackground = Color(0xFFFFB6C1);
  static const lightAppBarForeground = Color(0xFFFFFFFF);
  static const lightScaffoldBackground = Color(0xFFFFF0F6);
  static const lightCardBackground = Color(0xFFFFFFFF);
  static const lightNavigationBarBackground = Color(0xFFEDDDE5);
  static const lightTabSelected = Color(0xFFFFFFFF);
  static const lightTabUnselected = Color(0xFFFDECF3);

  // Dark
  static const darkAppBarBackground = Color(0xFFE882AE);
  static const darkAppBarForeground = Color(0xFFFDF1F6);
  static const darkScaffoldBackground = Color(0xFF24131C);
  static const darkCardBackground = Color(0xFF3A2531);
  static const darkNavigationBarBackground = Color(0xFF2D1823);
  static const darkTabSelected = Color(0xFFFDF1F6);
  static const darkTabUnselected = Color(0xFFF8D7E5);
}
