import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Horizontal row of tappable chips (replaces a static dropdown style control).
class PartStripSelector extends StatelessWidget {
  const PartStripSelector({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.optionLabel,
    this.chipFontFamily,
    this.chipFontFamilyFallback,
  });

  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  /// When non null, replaces the label shown on each chip (e.g. skin tone preview).
  final String Function(String value)? optionLabel;
  final String? chipFontFamily;
  final List<String>? chipFontFamilyFallback;

  static String _chipLabel(String value, String Function(String value)? transform) {
    if (value.isEmpty) {
      return '∅';
    }
    return transform?.call(value) ?? value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppStyle.spaceSm),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppStyle.spaceXs),
            itemCount: options.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppStyle.spaceSm),
            itemBuilder: (context, index) {
              final value = options[index];
              final isSelected = value == selected;
              return _PartChip(
                label: _chipLabel(value, optionLabel),
                selected: isSelected,
                onTap: () => onSelected(value),
                fontFamily: chipFontFamily,
                fontFamilyFallback: chipFontFamilyFallback,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Same chip strip, but each tap appends to the string instead of single selection mode.
class AppendStripSelector extends StatelessWidget {
  const AppendStripSelector({
    super.key,
    required this.label,
    required this.options,
    required this.onAppend,
    this.optionLabel,
    this.chipFontFamily,
    this.chipFontFamilyFallback,
  });

  final String label;
  final List<String> options;
  final ValueChanged<String> onAppend;
  final String Function(String value)? optionLabel;
  final String? chipFontFamily;
  final List<String>? chipFontFamilyFallback;

  static String _chipLabel(String value) => value.isEmpty ? '∅' : value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppStyle.spaceSm),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppStyle.spaceXs),
            itemCount: options.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppStyle.spaceSm),
            itemBuilder: (context, index) {
              final value = options[index];
              return _PartChip(
                label: optionLabel?.call(value) ?? _chipLabel(value),
                selected: false,
                onTap: () => onAppend(value),
                fontFamily: chipFontFamily,
                fontFamilyFallback: chipFontFamilyFallback,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PartChip extends StatelessWidget {
  const _PartChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.fontFamily,
    this.fontFamilyFallback,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: AppStyle.previewPulse,
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppStyle.spaceMd,
            vertical: AppStyle.spaceSm,
          ),
          constraints: const BoxConstraints(minWidth: 44, maxWidth: 96),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: selected
                ? scheme.primaryContainer
                : scheme.surfaceContainerHighest.withValues(alpha: 0.65),
            border: Border.all(
              width: selected ? 2 : 1,
              color: selected ? scheme.primary : scheme.outlineVariant,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  // Regular only for bundled Noto; heavier weights can faux-bold and break combining marks.
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                  fontFamily: fontFamily,
                  fontFamilyFallback: fontFamilyFallback,
                  color: selected
                      ? scheme.onPrimaryContainer
                      : scheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
