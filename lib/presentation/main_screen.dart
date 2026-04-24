import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../data/kaomoji_catalog_repository.dart';
import '../data/user_kaomoji_repository.dart';
import 'creator_screen.dart';
import 'emotions_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    this.catalogRepository,
    this.userRepository,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final KaomojiCatalogRepository? catalogRepository;
  final UserKaomojiRepository? userRepository;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final KaomojiCatalogRepository _catalogRepository;
  late final UserKaomojiRepository _userRepository;

  int _currentIndex = 0;
  final List<String> _savedKaomojis = <String>[];
  final List<String> _favoriteKaomojis = <String>[];
  Map<String, List<String>> _defaultKaomojis = <String, List<String>>{};
  bool _isLoadingDefaultKaomojis = true;
  String? _defaultKaomojisError;

  @override
  void initState() {
    super.initState();
    _catalogRepository = widget.catalogRepository ?? KaomojiCatalogRepository();
    _userRepository = widget.userRepository ?? UserKaomojiRepository();
    _loadDefaultKaomojis();
    _loadSavedKaomojis();
  }

  Future<void> _loadDefaultKaomojis() async {
    setState(() {
      _isLoadingDefaultKaomojis = true;
      _defaultKaomojisError = null;
    });
    try {
      final catalog = await _catalogRepository.loadCatalog();
      setState(() {
        _defaultKaomojis = catalog;
        _isLoadingDefaultKaomojis = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoadingDefaultKaomojis = false;
        _defaultKaomojisError = AppLocalizations.of(context).catalogLoadError;
      });
    }
  }

  Future<void> _loadSavedKaomojis() async {
    final stored = await _userRepository.readSaved();
    final favorites = await _userRepository.readFavorites();
    setState(() {
      _savedKaomojis
        ..clear()
        ..addAll(stored);
      _favoriteKaomojis
        ..clear()
        ..addAll(favorites);
    });
  }

  Future<void> _addCustomKaomoji(String kaomoji) async {
    final value = kaomoji.trim();
    if (value.isEmpty || _savedKaomojis.contains(value)) {
      return;
    }
    setState(() {
      _savedKaomojis.add(value);
    });
    await _userRepository.writeSaved(_savedKaomojis);
  }

  Future<void> _removeCustomKaomoji(String kaomoji) async {
    setState(() {
      _savedKaomojis.remove(kaomoji);
      _favoriteKaomojis.remove(kaomoji);
    });
    await _userRepository.writeSaved(_savedKaomojis);
    await _userRepository.writeFavorites(_favoriteKaomojis);
  }

  Future<void> _clearSavedKaomojis() async {
    final removedItems = List<String>.from(_savedKaomojis);
    setState(() {
      _savedKaomojis.clear();
      _favoriteKaomojis.removeWhere(removedItems.contains);
    });
    await _userRepository.writeSaved(_savedKaomojis);
    await _userRepository.writeFavorites(_favoriteKaomojis);
  }

  Future<void> _toggleFavoriteKaomoji(String kaomoji) async {
    setState(() {
      if (_favoriteKaomojis.contains(kaomoji)) {
        _favoriteKaomojis.remove(kaomoji);
      } else {
        _favoriteKaomojis.add(kaomoji);
      }
    });
    await _userRepository.writeFavorites(_favoriteKaomojis);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_isLoadingDefaultKaomojis) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_defaultKaomojisError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppStyle.spaceXxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _defaultKaomojisError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppStyle.spaceMd),
                FilledButton(
                  onPressed: _loadDefaultKaomojis,
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final pages = <Widget>[
      EmotionsScreen(
        themeMode: widget.themeMode,
        onThemeModeChanged: widget.onThemeModeChanged,
        defaultKaomojis: _defaultKaomojis,
        savedKaomojis: _savedKaomojis,
        favoriteKaomojis: _favoriteKaomojis,
        onDeleteSaved: _removeCustomKaomoji,
        onClearSaved: _clearSavedKaomojis,
        onToggleFavorite: _toggleFavoriteKaomoji,
      ),
      CreatorScreen(
        onSave: _addCustomKaomoji,
        onDeleteSaved: _removeCustomKaomoji,
        onClearSaved: _clearSavedKaomojis,
        onToggleFavorite: _toggleFavoriteKaomoji,
        savedKaomojis: _savedKaomojis,
        favoriteKaomojis: _favoriteKaomojis,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: const Icon(Icons.mood), label: l10n.emotionsTab),
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome),
            label: l10n.creatorTab,
          ),
        ],
      ),
    );
  }
}
