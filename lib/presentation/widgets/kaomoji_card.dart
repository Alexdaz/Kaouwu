import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kaouwu/core/constants/app_constants.dart';

class KaomojiCard extends StatefulWidget {
  const KaomojiCard({
    super.key,
    required this.kaomoji,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.onDelete,
  });

  final String kaomoji;
  final bool isFavorite;
  final Future<void> Function(String kaomoji) onToggleFavorite;
  final Future<void> Function(String kaomoji)? onDelete;

  @override
  State<KaomojiCard> createState() => _KaomojiCardState();
}

class _KaomojiCardState extends State<KaomojiCard> {
  bool _isPressed = false;

  Future<void> _copy(BuildContext context) async {
    setState(() {
      _isPressed = true;
    });
    await Clipboard.setData(ClipboardData(text: widget.kaomoji));
    await Future<void>.delayed(AppStyle.tapFeedback);
    if (mounted) {
      setState(() {
        _isPressed = false;
      });
    }
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.kaomoji} copiado',
          style: TextStyle(
            fontFamily: AppFonts.kaomojiDisplayFontFamily,
            fontFamilyFallback: AppFonts.kaomojiDisplayFallback,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kaomojiStyle = TextStyle(
      fontFamily: AppFonts.kaomojiDisplayFontFamily,
      fontFamilyFallback: AppFonts.kaomojiDisplayFallback,
      fontSize: AppStyle.kaomojiTileFontSize,
      fontWeight: FontWeight.w400,
      height: 1.2,
      color: theme.colorScheme.onSurface,
    );

    return AnimatedScale(
      duration: AppStyle.tapFeedback,
      scale: _isPressed ? AppStyle.scalePressed : 1,
      curve: Curves.easeOut,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => _copy(context),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppStyle.kaomojiCardInset),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.kaomoji,
                      textAlign: TextAlign.center,
                      style: kaomojiStyle,
                      locale: Localizations.localeOf(context),
                    ),
                  ),
                ),
              ),
              if (widget.onDelete != null)
                Positioned(
                  top: AppStyle.spaceXs,
                  right: AppStyle.spaceXs,
                  child: Material(
                    color: Theme.of(context).colorScheme.errorContainer,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => widget.onDelete?.call(widget.kaomoji),
                      child: Padding(
                        padding: const EdgeInsets.all(AppStyle.spaceXs),
                        child: Icon(
                          Icons.close,
                          size: AppStyle.badgeIconSize,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: AppStyle.spaceXs,
                left: AppStyle.spaceXs,
                child: Material(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => widget.onToggleFavorite(widget.kaomoji),
                    child: Padding(
                      padding: const EdgeInsets.all(AppStyle.spaceXs),
                      child: Icon(
                        widget.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: AppStyle.badgeIconSize,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
