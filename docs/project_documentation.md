# Project Documentation

## Project Structure

```text
lib/
  app.dart                         # App theme, localization, and root MaterialApp
  main.dart                        # Entry point
  core/                            # Constants, labels, helpers
  data/                            # Repositories (catalog, creator parts, user data, export)
  l10n/                            # Generated and source localization files
  presentation/                    # Screens and UI widgets
assets/
  data/                            # Kaomoji and creator parts JSON catalogs
  icon/                            # App icon source assets
docs/
  emoji_skin_tone.md               # Notes for skin tone handling
```

## Data Sources

- `assets/data/kaomojis.json`: default kaomoji catalog grouped by category.
- `assets/data/creator_parts.json`: parts used by the kaomoji creator screen.
- Saved and favorite kaomojis are persisted locally using `shared_preferences`.

## Icons and Native Splash

Launcher icon generation is configured in `pubspec.yaml` with `flutter_launcher_icons` (Only for iOS).

Native launch screen background is configured at:

- Android:
  - `android/app/src/main/res/drawable/launch_background.xml`
  - `android/app/src/main/res/drawable-v21/launch_background.xml`
  - `android/app/src/main/res/values/colors.xml`
  - `android/app/src/main/res/values-night/colors.xml`
- iOS:
  - `ios/Runner/Base.lproj/LaunchScreen.storyboard`
