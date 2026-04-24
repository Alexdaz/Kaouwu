import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @catalogLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load kaomojis.'**
  String get catalogLoadError;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Kaomojis for your day'**
  String get splashSubtitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @emotionsTab.
  ///
  /// In en, this message translates to:
  /// **'Emotions'**
  String get emotionsTab;

  /// No description provided for @creatorTab.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creatorTab;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @themeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose app appearance'**
  String get themeSubtitle;

  /// No description provided for @themeAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get themeAutomatic;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @licensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licensesTitle;

  /// No description provided for @licensesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses and fonts'**
  String get licensesSubtitle;

  /// No description provided for @exportTxtTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export to .txt'**
  String get exportTxtTooltip;

  /// No description provided for @exportFavorites.
  ///
  /// In en, this message translates to:
  /// **'Export favorites (.txt)'**
  String get exportFavorites;

  /// No description provided for @exportSaved.
  ///
  /// In en, this message translates to:
  /// **'Export saved (.txt)'**
  String get exportSaved;

  /// No description provided for @exportFavoritesFileNameBase.
  ///
  /// In en, this message translates to:
  /// **'kaouwu_favorites'**
  String get exportFavoritesFileNameBase;

  /// No description provided for @exportSavedFileNameBase.
  ///
  /// In en, this message translates to:
  /// **'kaouwu_saved'**
  String get exportSavedFileNameBase;

  /// No description provided for @exportFavoritesSubject.
  ///
  /// In en, this message translates to:
  /// **'Kaouwu — favorites'**
  String get exportFavoritesSubject;

  /// No description provided for @exportSavedSubject.
  ///
  /// In en, this message translates to:
  /// **'Kaouwu — saved'**
  String get exportSavedSubject;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @searchKaomojiHint.
  ///
  /// In en, this message translates to:
  /// **'Search kaomoji'**
  String get searchKaomojiHint;

  /// No description provided for @emptyCategoryMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no kaomojis in {categoryLabel} yet.'**
  String emptyCategoryMessage(Object categoryLabel);

  /// No description provided for @notFoundCategoryMessage.
  ///
  /// In en, this message translates to:
  /// **'No kaomojis found in {categoryLabel}.'**
  String notFoundCategoryMessage(Object categoryLabel);

  /// No description provided for @deleteKaomojiTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete kaomoji'**
  String get deleteKaomojiTitle;

  /// No description provided for @deleteKaomojiQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove {kaomoji} from saved?'**
  String deleteKaomojiQuestion(Object kaomoji);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @exportNoItems.
  ///
  /// In en, this message translates to:
  /// **'No kaomojis to export'**
  String get exportNoItems;

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'Could not export the file'**
  String get exportError;

  /// No description provided for @creatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Kaomoji Builder'**
  String get creatorTitle;

  /// No description provided for @skinToneTitle.
  ///
  /// In en, this message translates to:
  /// **'Skin tone (emojis)'**
  String get skinToneTitle;

  /// No description provided for @skinToneDescription.
  ///
  /// In en, this message translates to:
  /// **'Applied to toned hands and arms in preview and when copying or saving.'**
  String get skinToneDescription;

  /// No description provided for @randomMixTooltip.
  ///
  /// In en, this message translates to:
  /// **'Random mix'**
  String get randomMixTooltip;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewTitle;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Kaomoji copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @savedInApp.
  ///
  /// In en, this message translates to:
  /// **'Kaomoji saved in app'**
  String get savedInApp;

  /// No description provided for @decorationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Decorations (multiple)'**
  String get decorationsTitle;

  /// No description provided for @decorationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Before: at the start of the kaomoji (left). After: at the end (right). Tap the strip to add pieces; you can combine many.'**
  String get decorationsDescription;

  /// No description provided for @before.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get before;

  /// No description provided for @after.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get after;

  /// No description provided for @startBefore.
  ///
  /// In en, this message translates to:
  /// **'Start (Before)'**
  String get startBefore;

  /// No description provided for @endAfter.
  ///
  /// In en, this message translates to:
  /// **'End (After)'**
  String get endAfter;

  /// No description provided for @appendOnSideLabel.
  ///
  /// In en, this message translates to:
  /// **'Tap to append (side: {side})'**
  String appendOnSideLabel(Object side);

  /// No description provided for @leftArm.
  ///
  /// In en, this message translates to:
  /// **'Left arm'**
  String get leftArm;

  /// No description provided for @faceExpression.
  ///
  /// In en, this message translates to:
  /// **'Face / expression'**
  String get faceExpression;

  /// No description provided for @rightArm.
  ///
  /// In en, this message translates to:
  /// **'Right arm'**
  String get rightArm;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noneTapBelow.
  ///
  /// In en, this message translates to:
  /// **'(none - tap the strip below to append)'**
  String get noneTapBelow;

  /// No description provided for @savedSection.
  ///
  /// In en, this message translates to:
  /// **'Your saved'**
  String get savedSection;

  /// No description provided for @exportTxt.
  ///
  /// In en, this message translates to:
  /// **'Export .txt'**
  String get exportTxt;

  /// No description provided for @clearSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear saved'**
  String get clearSavedTitle;

  /// No description provided for @clearSavedQuestion.
  ///
  /// In en, this message translates to:
  /// **'All your saved kaomojis will be removed.'**
  String get clearSavedQuestion;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @savedDeleted.
  ///
  /// In en, this message translates to:
  /// **'Saved deleted'**
  String get savedDeleted;

  /// No description provided for @noSavedYet.
  ///
  /// In en, this message translates to:
  /// **'You do not have saved kaomojis yet.'**
  String get noSavedYet;

  /// No description provided for @noLicensesRegistered.
  ///
  /// In en, this message translates to:
  /// **'No licenses are registered.'**
  String get noLicensesRegistered;

  /// No description provided for @licensesLegalese.
  ///
  /// In en, this message translates to:
  /// **'This app includes third-party software and fonts distributed under open source licenses. The licenses registered by the Flutter engine and app packages are listed below.'**
  String get licensesLegalese;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
