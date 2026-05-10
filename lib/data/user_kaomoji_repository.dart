import 'package:shared_preferences/shared_preferences.dart';

import 'package:kaouwu/core/constants/app_constants.dart';

/// Persistence for saved kaomojis and favorites.
class UserKaomojiRepository {
  Future<List<String>> readSaved() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(StorageKeys.savedKaomojis) ?? <String>[];
  }

  Future<List<String>> readFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(StorageKeys.favoriteKaomojis) ?? <String>[];
  }

  Future<void> writeSaved(List<String> saved) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(StorageKeys.savedKaomojis, saved);
  }

  Future<void> writeFavorites(List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(StorageKeys.favoriteKaomojis, favorites);
  }
}
