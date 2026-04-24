import 'package:characters/characters.dart';

/// Fitzpatrick modifiers (U+1F3FB through U+1F3FF) for skin tone aware emoji.
abstract final class EmojiSkinTone {
  EmojiSkinTone._();

  static const int none = 0;
  static const int minTone = 1;
  static const int maxTone = 5;

  static const int _fe0f = 0xFE0F;
  static const int _minMod = 0x1F3FB;
  static const int _maxMod = 0x1F3FF;

  /// First scalars of clusters that accept a Fitzpatrick skin tone modifier.
  ///
  /// See `docs/emoji_skin_tone.md` for Unicode names, rationale, and how to extend this set.
  static const Set<int> kModifierBaseFirstScalars = {
    0x270A, 0x270B, 0x270C, 0x270D,
    0x1F44A, 0x1F44C, 0x1F44D, 0x1F44E,
    0x1F448, 0x1F449,
    0x1F590,
    0x1F596,
    0x1F918,
    0x1F919,
    0x1F91A,
    0x1F91B, 0x1F91C,
    0x1F91E,
    0x1F91F,
    0x1F4AA,
    0x1F90C,
    0x1F90F,
    0x1FAF0, 0x1FAF1, 0x1FAF2, 0x1FAF3,
    0x1FAF7, 0x1FAF8,
  };

  static bool _isFitzpatrick(int cp) => cp >= _minMod && cp <= _maxMod;

  /// Removes any existing skin tone modifiers.
  static String strip(String input) {
    final b = StringBuffer();
    for (final r in input.runes) {
      if (!_isFitzpatrick(r)) {
        b.writeCharCode(r);
      }
    }
    return b.toString();
  }

  static String? _modifierForIndex(int skinToneIndex) {
    if (skinToneIndex == none) {
      return null;
    }
    if (skinToneIndex < minTone || skinToneIndex > maxTone) {
      return null;
    }
    return String.fromCharCode(_minMod + (skinToneIndex - 1));
  }

  /// Applies [skinToneIndex] (0 means default, no tone) to every eligible grapheme cluster.
  static String apply(String input, int skinToneIndex) {
    final base = strip(input);
    final mod = _modifierForIndex(skinToneIndex);
    final out = StringBuffer();
    for (final g in base.characters) {
      if (mod == null) {
        out.write(_forceEmojiPresentation(g));
      } else {
        out.write(_applyToCluster(g, mod.runes.first));
      }
    }
    return out.toString();
  }

  static String _forceEmojiPresentation(String cluster) {
    final runes = cluster.runes.toList();
    if (runes.isEmpty) {
      return cluster;
    }
    final r0 = runes.first;
    if (!kModifierBaseFirstScalars.contains(r0)) {
      return cluster;
    }
    if (runes.length >= 2 && runes[1] == _fe0f) {
      return cluster;
    }
    final rest = runes.length > 1 ? String.fromCharCodes(runes.sublist(1)) : '';
    return '${String.fromCharCode(r0)}${String.fromCharCode(_fe0f)}$rest';
  }

  static String _applyToCluster(String cluster, int modCp) {
    final runes = cluster.runes.toList();
    if (runes.isEmpty) {
      return cluster;
    }
    final r0 = runes.first;
    if (!kModifierBaseFirstScalars.contains(r0)) {
      return cluster;
    }
    if (runes.length >= 2 && _isFitzpatrick(runes[1])) {
      return cluster;
    }
    if (runes.length >= 2 && runes[1] == _fe0f) {
      // Recommended order for tone: base, modifier, then remainder, without VS16 between base and modifier.
      final rest = runes.length > 2 ? String.fromCharCodes(runes.sublist(2)) : '';
      return '${String.fromCharCode(r0)}${String.fromCharCode(modCp)}$rest';
    }
    final rest =
        runes.length > 1 ? String.fromCharCodes(runes.sublist(1)) : '';
    return '${String.fromCharCode(r0)}${String.fromCharCode(modCp)}$rest';
  }
}
