import 'dart:convert';

import 'package:flutter/services.dart';

import '../core/constants/app_constants.dart';

/// Minimal embedded parts if the JSON asset is missing or invalid (not a full duplicate catalog).
const List<String> _kFallbackDecorations = [
  '',
  '✿',
  '★',
  '♡',
  '｡',
  '✨',
];

const List<String> _kFallbackLeftArms = [
  '(',
  'ʕ',
  '╰',
  '୧',
  '༼',
  '(つ',
  '(｡',
  '(＾',
];

const List<String> _kFallbackRightArms = [
  ')',
  'ʔ',
  '╯',
  '୨',
  '༽',
  'つ)',
  '｡)',
  '＾)',
];

const List<String> _kFallbackFaces = [
  '•ᴗ•',
  '◕‿◕',
  '≧◡≦',
  'UwU',
  'OwO',
  '^_^',
  '•ω•',
  '≧▽≦',
];

/// Creator parts loaded from JSON with the minimal embedded fallback above.
class CreatorPartsBundle {
  const CreatorPartsBundle({
    required this.decorations,
    required this.leftArms,
    required this.faces,
    required this.rightArms,
  });

  final List<String> decorations;
  final List<String> leftArms;
  final List<String> faces;
  final List<String> rightArms;

  factory CreatorPartsBundle.fallback() {
    return CreatorPartsBundle(
      decorations: List<String>.from(_kFallbackDecorations),
      leftArms: List<String>.from(_kFallbackLeftArms),
      faces: List<String>.from(_kFallbackFaces),
      rightArms: List<String>.from(_kFallbackRightArms),
    );
  }

  factory CreatorPartsBundle.fromJson(Map<String, dynamic> json) {
    List<String> readList(String key) {
      final raw = json[key];
      if (raw is! List) {
        return <String>[];
      }
      return raw.map((e) => e.toString()).toList();
    }

    return CreatorPartsBundle(
      decorations: readList('decorations'),
      leftArms: readList('leftArms'),
      faces: readList('faces'),
      rightArms: readList('rightArms'),
    );
  }

  bool get isUsable =>
      decorations.isNotEmpty &&
      leftArms.isNotEmpty &&
      faces.isNotEmpty &&
      rightArms.isNotEmpty;
}

class CreatorPartsRepository {
  CreatorPartsRepository({this.assetPath = AssetPaths.creatorParts});

  final String assetPath;

  Future<CreatorPartsBundle> load() async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return CreatorPartsBundle.fallback();
      }
      final bundle = CreatorPartsBundle.fromJson(decoded);
      if (!bundle.isUsable) {
        return CreatorPartsBundle.fallback();
      }
      return bundle;
    } catch (_) {
      return CreatorPartsBundle.fallback();
    }
  }
}
