import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';

/// Shares a list of kaomojis as a `.txt` file using the native share sheet on iOS and Android.
abstract final class KaomojiTxtExport {
  static String _safeFileName(String base) {
    final s = base.replaceAll(RegExp(r'[^\w\-]'), '_');
    return s.isEmpty ? 'kaouwu_export' : s;
  }

  /// `yyyyMMdd_HHmmss` so each export gets a unique file name.
  static String _timestampSuffix(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}${two(d.month)}${two(d.day)}_${two(d.hour)}'
        '${two(d.minute)}${two(d.second)}';
  }

  static Rect? _shareOrigin(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      return null;
    }
    return box.localToGlobal(Offset.zero) & box.size;
  }

  static Future<void> shareList(
    BuildContext context, {
    required List<String> kaomojis,
    required String fileNameBase,
    String subject = 'Kaouwu',
  }) async {
    final lines = kaomojis
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (lines.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).exportNoItems)),
        );
      }
      return;
    }

    final base = _safeFileName(fileNameBase);
    final stamped = '${base}_${_timestampSuffix(DateTime.now())}';
    final bytes = Uint8List.fromList(utf8.encode(lines.join('\n')));

    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes,
              mimeType: 'text/plain',
              name: '$stamped.txt',
            ),
          ],
          fileNameOverrides: <String>['$stamped.txt'],
          subject: subject,
          sharePositionOrigin: _shareOrigin(context),
        ),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).exportError)),
        );
      }
    }
  }
}
