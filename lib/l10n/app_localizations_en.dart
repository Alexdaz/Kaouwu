// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get catalogLoadError => 'Could not load kaomojis.';

  @override
  String get splashSubtitle => 'Kaomojis for your day';

  @override
  String get retry => 'Retry';

  @override
  String get emotionsTab => 'Emotions';

  @override
  String get creatorTab => 'Creator';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeSubtitle => 'Choose app appearance';

  @override
  String get themeAutomatic => 'Automatic';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get licensesTitle => 'Licenses';

  @override
  String get licensesSubtitle => 'Open source licenses and fonts';

  @override
  String get exportTxtTooltip => 'Export to .txt';

  @override
  String get exportFavorites => 'Export favorites (.txt)';

  @override
  String get exportSaved => 'Export saved (.txt)';

  @override
  String get exportFavoritesFileNameBase => 'kaouwu_favorites';

  @override
  String get exportSavedFileNameBase => 'kaouwu_saved';

  @override
  String get exportFavoritesSubject => 'Kaouwu — favorites';

  @override
  String get exportSavedSubject => 'Kaouwu — saved';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get searchKaomojiHint => 'Search kaomoji';

  @override
  String get emotionFavorites => 'Favorites';

  @override
  String get emotionSaved => 'Saved';

  @override
  String get emotionHappy => 'Happy';

  @override
  String get emotionSad => 'Sad';

  @override
  String get emotionAngry => 'Angry';

  @override
  String get emotionLove => 'Love';

  @override
  String get emotionSurprised => 'Surprised';

  @override
  String get emotionShy => 'Shy';

  @override
  String get emotionSleepy => 'Sleepy';

  @override
  String get emotionConfused => 'Confused';

  @override
  String get emotionNervous => 'Nervous';

  @override
  String get emotionEmbarrassed => 'Embarrassed';

  @override
  String get emotionProud => 'Proud';

  @override
  String get emotionGreeting => 'Greeting';

  @override
  String get emotionCelebrating => 'Celebrating';

  @override
  String emptyCategoryMessage(Object categoryLabel) {
    return 'There are no kaomojis in $categoryLabel yet.';
  }

  @override
  String notFoundCategoryMessage(Object categoryLabel) {
    return 'No kaomojis found in $categoryLabel.';
  }

  @override
  String get deleteKaomojiTitle => 'Delete kaomoji';

  @override
  String deleteKaomojiQuestion(Object kaomoji) {
    return 'Do you want to remove $kaomoji from saved?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get exportNoItems => 'No kaomojis to export';

  @override
  String get exportError => 'Could not export the file';

  @override
  String get creatorTitle => 'Kaomoji Builder';

  @override
  String get skinToneTitle => 'Skin tone (emojis)';

  @override
  String get skinToneDescription =>
      'Applied to toned hands and arms in preview and when copying or saving.';

  @override
  String get randomMixTooltip => 'Random mix';

  @override
  String get previewTitle => 'Preview';

  @override
  String get copy => 'Copy';

  @override
  String get save => 'Save';

  @override
  String get copiedToClipboard => 'Kaomoji copied to clipboard';

  @override
  String get savedInApp => 'Kaomoji saved in app';

  @override
  String get decorationsTitle => 'Decorations (multiple)';

  @override
  String get decorationsDescription =>
      'Before: at the start of the kaomoji (left). After: at the end (right). Tap the strip to add pieces; you can combine many.';

  @override
  String get before => 'Before';

  @override
  String get after => 'After';

  @override
  String get startBefore => 'Start (Before)';

  @override
  String get endAfter => 'End (After)';

  @override
  String appendOnSideLabel(Object side) {
    return 'Tap to append (side: $side)';
  }

  @override
  String get leftArm => 'Left arm';

  @override
  String get faceExpression => 'Face / expression';

  @override
  String get rightArm => 'Right arm';

  @override
  String get clear => 'Clear';

  @override
  String get noneTapBelow => '(none - tap the strip below to append)';

  @override
  String get savedSection => 'Your saved';

  @override
  String get exportTxt => 'Export .txt';

  @override
  String get clearSavedTitle => 'Clear saved';

  @override
  String get clearSavedQuestion => 'All your saved kaomojis will be removed.';

  @override
  String get clearAll => 'Clear all';

  @override
  String get savedDeleted => 'Saved deleted';

  @override
  String get noSavedYet => 'You do not have saved kaomojis yet.';

  @override
  String get noLicensesRegistered => 'No licenses are registered.';

  @override
  String get licensesLegalese =>
      'This app includes third-party software and fonts distributed under open source licenses. The licenses registered by the Flutter engine and app packages are listed below.';
}
