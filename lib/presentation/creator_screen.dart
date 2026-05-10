import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kaouwu/core/constants/app_constants.dart';
import 'package:kaouwu/core/emoji_skin_tone.dart';
import 'package:kaouwu/data/creator_parts_repository.dart';
import 'package:kaouwu/data/kaomoji_txt_export.dart';
import 'package:kaouwu/l10n/app_localizations.dart';
import 'package:kaouwu/presentation/widgets/kaomoji_grid.dart';
import 'package:kaouwu/presentation/widgets/part_strip_selector.dart';

enum _DecoTarget { antes, despues }

class CreatorScreen extends StatefulWidget {
  const CreatorScreen({
    super.key,
    required this.onSave,
    required this.onDeleteSaved,
    required this.onClearSaved,
    required this.onToggleFavorite,
    required this.savedKaomojis,
    required this.favoriteKaomojis,
  });

  final Future<void> Function(String kaomoji) onSave;
  final Future<void> Function(String kaomoji) onDeleteSaved;
  final Future<void> Function() onClearSaved;
  final Future<void> Function(String kaomoji) onToggleFavorite;
  final List<String> savedKaomojis;
  final List<String> favoriteKaomojis;

  @override
  State<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen> {
  final CreatorPartsRepository _partsRepo = CreatorPartsRepository();

  CreatorPartsBundle? _bundle;
  final List<String> _decorationAntes = <String>[];
  final List<String> _decorationDespues = <String>[];
  _DecoTarget _decoTarget = _DecoTarget.antes;
  String _selectedLeftArm = '';
  String _selectedFace = '';
  String _selectedRightArm = '';
  int _skinToneIndex = EmojiSkinTone.none;
  bool _animateCopy = false;
  bool _animateSave = false;

  String get _tonedDecorBefore =>
      EmojiSkinTone.apply(_decorationAntes.join(), _skinToneIndex);
  String get _tonedDecorAfter =>
      EmojiSkinTone.apply(_decorationDespues.join(), _skinToneIndex);
  String get _tonedLeftArm =>
      EmojiSkinTone.apply(_selectedLeftArm, _skinToneIndex);
  String get _tonedRightArm =>
      EmojiSkinTone.apply(_selectedRightArm, _skinToneIndex);

  String get _composedKaomoji =>
      '$_tonedDecorBefore'
      '$_tonedLeftArm'
      '$_selectedFace'
      '$_tonedRightArm'
      '$_tonedDecorAfter';

  @override
  void initState() {
    super.initState();
    _loadSavedSkinTone();
    _loadCreatorParts();
  }

  Future<void> _loadSavedSkinTone() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(StorageKeys.skinToneIndex);
    if (saved == null || !mounted) {
      return;
    }
    final normalized = saved.clamp(EmojiSkinTone.none, EmojiSkinTone.maxTone);
    setState(() => _skinToneIndex = normalized.toInt());
  }

  Future<void> _saveSkinTone(int toneIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(StorageKeys.skinToneIndex, toneIndex);
  }

  Future<void> _loadCreatorParts() async {
    final loaded = await _partsRepo.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _bundle = loaded;
      _selectedLeftArm = loaded.leftArms.first;
      _selectedFace = loaded.faces.first;
      _selectedRightArm = loaded.rightArms.first;
    });
  }

  void _appendDecoration(String value) {
    if (value.isEmpty) {
      return;
    }
    setState(() {
      if (_decoTarget == _DecoTarget.antes) {
        _decorationAntes.add(value);
      } else {
        _decorationDespues.add(value);
      }
    });
    HapticFeedback.selectionClick();
  }

  void _randomMix() {
    final b = _bundle;
    if (b == null) {
      return;
    }
    final r = Random();
    final pool = b.decorations.where((e) => e.isNotEmpty).toList();
    if (pool.isEmpty) {
      return;
    }
    List<String> randomChain() {
      final n = r.nextInt(4);
      return List.generate(n, (_) => pool[r.nextInt(pool.length)]);
    }

    setState(() {
      _decorationAntes
        ..clear()
        ..addAll(randomChain());
      _decorationDespues
        ..clear()
        ..addAll(randomChain());
      _selectedLeftArm = b.leftArms[r.nextInt(b.leftArms.length)];
      _selectedFace = b.faces[r.nextInt(b.faces.length)];
      _selectedRightArm = b.rightArms[r.nextInt(b.rightArms.length)];
    });
    HapticFeedback.selectionClick();
  }

  Future<void> _showSkinTonePicker() async {
    if (_bundle == null) {
      return;
    }
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final choice = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        const previews = ['✋️', '✋🏻', '✋🏼', '✋🏽', '✋🏾', '✋🏿'];
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppStyle.spaceLg,
                    AppStyle.spaceSm,
                    AppStyle.spaceLg,
                    AppStyle.spaceXs,
                  ),
                  child: Text(
                    l10n.skinToneTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyle.spaceLg,
                  ),
                  child: Text(
                    l10n.skinToneDescription,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: AppStyle.spaceSm),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppStyle.spaceLg,
                    0,
                    AppStyle.spaceLg,
                    AppStyle.spaceSm,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: previews.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: AppStyle.spaceSm,
                      mainAxisSpacing: AppStyle.spaceSm,
                      childAspectRatio: 1.7,
                    ),
                    itemBuilder: (context, i) {
                      final selected = _skinToneIndex == i;
                      const tileRadius = 12.0;
                      return AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOutCubic,
                        scale: selected ? 1.02 : 1,
                        child: Material(
                          color: selected
                              ? theme.colorScheme.primaryContainer.withValues(
                                  alpha: 0.45,
                                )
                              : theme.colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(tileRadius),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(tileRadius),
                            overlayColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.pressed)) {
                                return theme.colorScheme.primary.withValues(
                                  alpha: 0.18,
                                );
                              }
                              if (states.contains(WidgetState.hovered)) {
                                return theme.colorScheme.primary.withValues(
                                  alpha: 0.10,
                                );
                              }
                              if (states.contains(WidgetState.focused)) {
                                return theme.colorScheme.primary.withValues(
                                  alpha: 0.12,
                                );
                              }
                              return null;
                            }),
                            onTap: () => Navigator.pop(ctx, i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOutCubic,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(tileRadius),
                                border: Border.all(
                                  color: selected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outlineVariant,
                                  width: selected ? 2 : 1.1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                previews[i],
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (choice == null || !mounted) {
      return;
    }
    setState(() => _skinToneIndex = choice);
    await _saveSkinTone(choice);
    HapticFeedback.selectionClick();
  }

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

  Future<void> _copyResult(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _composedKaomoji));
    setState(() {
      _animateCopy = true;
    });
    await Future<void>.delayed(AppStyle.previewPulse);
    if (mounted) {
      setState(() {
        _animateCopy = false;
      });
    }
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).copiedToClipboard)),
    );
  }

  Future<void> _saveResult(BuildContext context) async {
    await widget.onSave(_composedKaomoji);
    setState(() {
      _animateSave = true;
    });
    await Future<void>.delayed(AppStyle.previewPulse);
    if (mounted) {
      setState(() {
        _animateSave = false;
      });
    }
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).savedInApp)),
    );
  }

  Widget _decorationChainRow({
    required String title,
    required List<String> parts,
    required VoidCallback onClear,
    required void Function(int index) onRemoveAt,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: parts.isEmpty ? null : onClear,
              child: Text(AppLocalizations.of(context).clear),
            ),
          ],
        ),
        const SizedBox(height: AppStyle.spaceXs),
        if (parts.isEmpty)
          Text(
            AppLocalizations.of(context).noneTapBelow,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          )
        else
          Wrap(
            spacing: AppStyle.spaceSm,
            runSpacing: AppStyle.spaceSm,
            children: List.generate(parts.length, (i) {
              final piece = parts[i];
              return InputChip(
                label: Text(
                  piece.isEmpty ? '∅' : piece,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    color: theme.colorScheme.onSurface,
                    fontFamily: AppFonts.kaomojiDisplayFontFamily,
                    fontFamilyFallback: AppFonts.kaomojiDisplayFallback,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onDeleted: () => onRemoveAt(i),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bundle = _bundle;
    final scheme = Theme.of(context).colorScheme;
    final previewPulsing = _animateCopy || _animateSave;
    final onPreview = previewPulsing
        ? scheme.onSecondaryContainer
        : scheme.onPrimaryContainer;
    const previewEmojiStyle = TextStyle(
      fontFamily: 'Noto Color Emoji',
      fontFamilyFallback: AppFonts.baseFallback,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).creatorTitle),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).skinToneTitle,
            onPressed: _showSkinTonePicker,
            icon: const Icon(Icons.palette_outlined),
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).randomMixTooltip,
            onPressed: _randomMix,
            icon: const Icon(Icons.auto_awesome),
          ),
        ],
      ),
      body: bundle == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppStyle.pagePadding),
              children: [
                AnimatedScale(
                  duration: AppStyle.previewPulse,
                  scale: (_animateCopy || _animateSave)
                      ? AppStyle.scaleEmphasis
                      : 1,
                  curve: Curves.easeOutBack,
                  child: AnimatedContainer(
                    duration: AppStyle.previewPulse,
                    curve: Curves.easeInOut,
                    child: Card(
                      elevation: 0,
                      color: previewPulsing
                          ? scheme.secondaryContainer
                          : scheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(AppStyle.spaceXl),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context).previewTitle,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: onPreview),
                            ),
                            const SizedBox(height: AppStyle.spaceCompact),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: SelectableText.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: _tonedDecorBefore,
                                      style: previewEmojiStyle,
                                    ),
                                    TextSpan(
                                      text: _tonedLeftArm,
                                      style: previewEmojiStyle,
                                    ),
                                    TextSpan(text: _selectedFace),
                                    TextSpan(
                                      text: _tonedRightArm,
                                      style: previewEmojiStyle,
                                    ),
                                    TextSpan(
                                      text: _tonedDecorAfter,
                                      style: previewEmojiStyle,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      // In preview, prioritize bundled color emoji for default yellow tone.
                                      fontFamily: AppFonts.kaomojiDisplayFontFamily,
                                      fontFamilyFallback:
                                          AppFonts.decorationFallback,
                                      fontWeight: FontWeight.w400,
                                      color: onPreview,
                                      height: 1.2,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppStyle.spaceMd),
                Wrap(
                  spacing: AppStyle.spaceSm,
                  runSpacing: AppStyle.spaceSm,
                  alignment: WrapAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _copyResult(context),
                      icon: const Icon(Icons.copy),
                      label: Text(AppLocalizations.of(context).copy),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _saveResult(context),
                      icon: const Icon(Icons.save),
                      label: Text(AppLocalizations.of(context).save),
                    ),
                  ],
                ),
                const SizedBox(height: AppStyle.spaceLg),
                Text(
                  AppLocalizations.of(context).decorationsTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppStyle.spaceXs),
                Text(
                  AppLocalizations.of(context).decorationsDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppStyle.spaceMd),
                SegmentedButton<_DecoTarget>(
                  segments: [
                    ButtonSegment(
                      value: _DecoTarget.antes,
                      label: Text(AppLocalizations.of(context).before),
                      icon: Icon(Icons.arrow_back, size: 18),
                    ),
                    ButtonSegment(
                      value: _DecoTarget.despues,
                      label: Text(AppLocalizations.of(context).after),
                      icon: Icon(Icons.arrow_forward, size: 18),
                    ),
                  ],
                  selected: {_decoTarget},
                  onSelectionChanged: (Set<_DecoTarget> next) {
                    if (next.isEmpty) {
                      return;
                    }
                    setState(() => _decoTarget = next.first);
                  },
                ),
                const SizedBox(height: AppStyle.spaceMd),
                _decorationChainRow(
                  title: AppLocalizations.of(context).startBefore,
                  parts: _decorationAntes,
                  onClear: () => setState(_decorationAntes.clear),
                  onRemoveAt: (i) =>
                      setState(() => _decorationAntes.removeAt(i)),
                ),
                const SizedBox(height: AppStyle.spaceMd),
                _decorationChainRow(
                  title: AppLocalizations.of(context).endAfter,
                  parts: _decorationDespues,
                  onClear: () => setState(_decorationDespues.clear),
                  onRemoveAt: (i) =>
                      setState(() => _decorationDespues.removeAt(i)),
                ),
                const SizedBox(height: AppStyle.spaceMd),
                AppendStripSelector(
                  label:
                      AppLocalizations.of(context).appendOnSideLabel(
                        _decoTarget == _DecoTarget.antes
                            ? AppLocalizations.of(context).before
                            : AppLocalizations.of(context).after,
                      ),
                  options: bundle.decorations,
                  chipFontFamily: AppFonts.kaomojiDisplayFontFamily,
                  chipFontFamilyFallback: AppFonts.kaomojiDisplayFallback,
                  onAppend: _appendDecoration,
                ),
                const SizedBox(height: AppStyle.spaceMd),
                PartStripSelector(
                  label: AppLocalizations.of(context).leftArm,
                  options: bundle.leftArms,
                  selected: _selectedLeftArm,
                  onSelected: (v) => setState(() => _selectedLeftArm = v),
                  optionLabel: (v) =>
                      EmojiSkinTone.apply(v, _skinToneIndex),
                  // Keep system emoji rendering here so Samsung devices use color emoji for default tone.
                  chipFontFamilyFallback: AppFonts.baseFallback,
                ),
                const SizedBox(height: AppStyle.spaceMd),
                PartStripSelector(
                  label: AppLocalizations.of(context).faceExpression,
                  options: bundle.faces,
                  selected: _selectedFace,
                  onSelected: (v) => setState(() => _selectedFace = v),
                  chipFontFamily: AppFonts.kaomojiDisplayFontFamily,
                  chipFontFamilyFallback: AppFonts.kaomojiDisplayFallback,
                ),
                const SizedBox(height: AppStyle.spaceMd),
                PartStripSelector(
                  label: AppLocalizations.of(context).rightArm,
                  options: bundle.rightArms,
                  selected: _selectedRightArm,
                  onSelected: (v) => setState(() => _selectedRightArm = v),
                  optionLabel: (v) =>
                      EmojiSkinTone.apply(v, _skinToneIndex),
                  // Keep system emoji rendering here so Samsung devices use color emoji for default tone.
                  chipFontFamilyFallback: AppFonts.baseFallback,
                ),
                if (widget.savedKaomojis.isNotEmpty) ...[
                  const SizedBox(height: AppStyle.spaceXxl),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).savedSection,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () => KaomojiTxtExport.shareList(
                          context,
                          kaomojis: widget.savedKaomojis,
                          fileNameBase:
                              AppLocalizations.of(context).exportSavedFileNameBase,
                          subject: AppLocalizations.of(context).exportSavedSubject,
                        ),
                        child: Text(AppLocalizations.of(context).exportTxt),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final ok = await _confirmAction(
                            title: AppLocalizations.of(context).clearSavedTitle,
                            message: AppLocalizations.of(context).clearSavedQuestion,
                            confirmText: AppLocalizations.of(context).clearAll,
                          );
                          if (!ok) {
                            return;
                          }
                          await widget.onClearSaved();
                          if (!context.mounted) {
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context).savedDeleted),
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_sweep),
                        label: Text(AppLocalizations.of(context).clearAll),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppStyle.spaceMd),
                  KaomojiGrid(
                    kaomojis: widget.savedKaomojis,
                    favoriteKaomojis: widget.favoriteKaomojis,
                    emptyMessage: AppLocalizations.of(context).noSavedYet,
                    shrinkWrap: true,
                    scrollable: false,
                    onToggleFavorite: widget.onToggleFavorite,
                    onDelete: (kaomoji) async {
                      final ok = await _confirmAction(
                        title: AppLocalizations.of(context).deleteKaomojiTitle,
                        message: AppLocalizations.of(context).deleteKaomojiQuestion(
                          kaomoji,
                        ),
                        confirmText: AppLocalizations.of(context).delete,
                      );
                      if (!ok) {
                        return;
                      }
                      await widget.onDeleteSaved(kaomoji);
                    },
                  ),
                ],
              ],
            ),
    );
  }
}
