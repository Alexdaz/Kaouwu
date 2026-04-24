import 'dart:convert';

import 'package:flutter/services.dart';

import '../core/constants/app_constants.dart';

/// Loads and parses the kaomoji catalog from a JSON asset.
class KaomojiCatalogRepository {
  KaomojiCatalogRepository({this.assetPath = AssetPaths.kaomojisCatalog});

  final String assetPath;

  /// Map from emotion key (English) to kaomoji strings.
  Future<Map<String, List<String>>> loadCatalog() async {
    final jsonString = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(jsonString);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid JSON for kaomojis');
    }
    
    return decoded.map((key, value) {
      final list = value is List
          ? value.map((item) => item.toString()).toList()
          : <String>[];
      return MapEntry<String, List<String>>(key, list);
    });
  }
}
