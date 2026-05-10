import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kaouwu/core/app_strings.dart';
import 'package:kaouwu/core/constants/app_constants.dart';
import 'package:kaouwu/core/emotion_category_ids.dart';
import 'package:kaouwu/data/kaomoji_txt_export.dart';
import 'package:kaouwu/l10n/app_localizations.dart';
import 'package:kaouwu/presentation/settings_screen.dart';
import 'package:kaouwu/presentation/widgets/kaomoji_grid.dart';

String _emotionLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case EmotionCategoryIds.favorites:
      return l10n.emotionFavorites;
    case EmotionCategoryIds.saved:
      return l10n.emotionSaved;
    case 'happy':
      return l10n.emotionHappy;
    case 'sad':
      return l10n.emotionSad;
    case 'angry':
      return l10n.emotionAngry;
    case 'love':
      return l10n.emotionLove;
    case 'surprised':
      return l10n.emotionSurprised;
    case 'shy':
      return l10n.emotionShy;
    case 'sleepy':
      return l10n.emotionSleepy;
    case 'confused':
      return l10n.emotionConfused;
    case 'nervous':
      return l10n.emotionNervous;
    case 'embarrassed':
      return l10n.emotionEmbarrassed;
    case 'proud':
      return l10n.emotionProud;
    case 'greeting':
      return l10n.emotionGreeting;
    case 'celebrating':
      return l10n.emotionCelebrating;
    default:
      return key;
  }
}

class EmotionsScreen extends StatefulWidget {
  const EmotionsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.defaultKaomojis,
    required this.savedKaomojis,
    required this.favoriteKaomojis,
    required this.onDeleteSaved,
    required this.onClearSaved,
    required this.onToggleFavorite,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final Map<String, List<String>> defaultKaomojis;
  final List<String> savedKaomojis;
  final List<String> favoriteKaomojis;
  final Future<void> Function(String kaomoji) onDeleteSaved;
  final Future<void> Function() onClearSaved;
  final Future<void> Function(String kaomoji) onToggleFavorite;

  @override
  State<EmotionsScreen> createState() => _EmotionsScreenState();
}

class _EmotionsScreenState extends State<EmotionsScreen> {
  String _query = '';

  Future<bool> _confirmAction({
    required String title,
    required String message,
    required String confirmText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = <MapEntry<String, List<String>>>[
      if (widget.favoriteKaomojis.isNotEmpty)
        MapEntry<String, List<String>>(
          EmotionCategoryIds.favorites,
          widget.favoriteKaomojis,
        ),
      ...widget.defaultKaomojis.entries,
      if (widget.savedKaomojis.isNotEmpty)
        MapEntry<String, List<String>>(
          EmotionCategoryIds.saved,
          widget.savedKaomojis,
        ),
    ];

    return DefaultTabController(
      length: entries.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppStrings.appTitle,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w700,
              letterSpacing: AppStyle.appBarTitleLetterSpacing,
              color: Theme.of(context).colorScheme.onSurface,
            ).copyWith(
              fontFamilyFallback: AppFonts.baseFallback,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: entries
                .map((entry) => Tab(text: _emotionLabel(l10n, entry.key)))
                .toList(),
          ),
          actions: [
            if (widget.favoriteKaomojis.isNotEmpty ||
                widget.savedKaomojis.isNotEmpty)
              PopupMenuButton<String>(
                tooltip: l10n.exportTxtTooltip,
                icon: const Icon(Icons.upload_file),
                onSelected: (value) async {
                  if (value == 'fav') {
                    await KaomojiTxtExport.shareList(
                      context,
                      kaomojis: widget.favoriteKaomojis,
                      fileNameBase: l10n.exportFavoritesFileNameBase,
                      subject: l10n.exportFavoritesSubject,
                    );
                  } else if (value == 'saved') {
                    await KaomojiTxtExport.shareList(
                      context,
                      kaomojis: widget.savedKaomojis,
                      fileNameBase: l10n.exportSavedFileNameBase,
                      subject: l10n.exportSavedSubject,
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'fav',
                    enabled: widget.favoriteKaomojis.isNotEmpty,
                    child: Text(l10n.exportFavorites),
                  ),
                  PopupMenuItem<String>(
                    value: 'saved',
                    enabled: widget.savedKaomojis.isNotEmpty,
                    child: Text(l10n.exportSaved),
                  ),
                ],
              ),
            IconButton(
              tooltip: l10n.settingsTooltip,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (context) => SettingsScreen(
                      themeMode: widget.themeMode,
                      onThemeModeChanged: widget.onThemeModeChanged,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppStyle.spaceMd,
                AppStyle.spaceMd,
                AppStyle.spaceMd,
                AppStyle.spaceXs,
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _query = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: l10n.searchKaomojiHint,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: entries.map((entry) {
                  final filtered = _query.isEmpty
                      ? entry.value
                      : entry.value
                            .where((k) => k.toLowerCase().contains(_query))
                            .toList();
                  final isSavedCategory = entry.key == EmotionCategoryIds.saved;
                  final categoryLabel = _emotionLabel(l10n, entry.key);

                  return KaomojiGrid(
                    kaomojis: filtered,
                    favoriteKaomojis: widget.favoriteKaomojis,
                    emptyMessage: _query.isEmpty
                        ? l10n.emptyCategoryMessage(categoryLabel)
                        : l10n.notFoundCategoryMessage(categoryLabel),
                    onToggleFavorite: widget.onToggleFavorite,
                    onDelete: isSavedCategory
                        ? (kaomoji) async {
                            final ok = await _confirmAction(
                              title: l10n.deleteKaomojiTitle,
                              message: l10n.deleteKaomojiQuestion(kaomoji),
                              confirmText: l10n.delete,
                            );
                            if (!ok) {
                              return;
                            }
                            await widget.onDeleteSaved(kaomoji);
                          }
                        : null,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
