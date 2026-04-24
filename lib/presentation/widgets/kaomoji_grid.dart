import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import 'kaomoji_card.dart';

class KaomojiGrid extends StatelessWidget {
  const KaomojiGrid({
    super.key,
    required this.kaomojis,
    required this.favoriteKaomojis,
    required this.emptyMessage,
    required this.onToggleFavorite,
    this.onDelete,
    this.shrinkWrap = false,
    this.scrollable = true,
  });

  final List<String> kaomojis;
  final List<String> favoriteKaomojis;
  final String emptyMessage;
  final Future<void> Function(String kaomoji) onToggleFavorite;
  final Future<void> Function(String kaomoji)? onDelete;
  final bool shrinkWrap;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    if (kaomojis.isEmpty) {
      final scheme = Theme.of(context).colorScheme;
      return Center(
        child: Text(
          emptyMessage,
          textAlign: TextAlign.center,
          style: TextStyle(color: scheme.onSurface),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppStyle.gridPadding),
      shrinkWrap: shrinkWrap,
      physics: scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: kaomojis.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppStyle.gridColumns,
        crossAxisSpacing: AppStyle.gridSpacing,
        mainAxisSpacing: AppStyle.gridSpacing,
        childAspectRatio: AppStyle.gridTileAspectRatio,
      ),
      itemBuilder: (context, index) {
        final kaomoji = kaomojis[index];
        return KaomojiCard(
          kaomoji: kaomoji,
          isFavorite: favoriteKaomojis.contains(kaomoji),
          onToggleFavorite: onToggleFavorite,
          onDelete: onDelete,
        );
      },
    );
  }
}
