# Emoji skin tone handling

This document describes how `lib/core/emoji_skin_tone.dart` picks emoji clusters that support **Fitzpatrick skin tone modifiers** (Unicode code points U+1F3FB through U+1F3FF). Contributors can extend the set in `EmojiSkinTone.kModifierBaseFirstScalars` when the app should apply or normalize tone for new emoji bases.

## Background

Many emoji depicting people and body parts are defined as a **base character** optionally followed by a skin tone modifier. The modifier must appear in the order defined by [UTS #51 Unicode Emoji](https://www.unicode.org/reports/tr51/) (see also the published emoji sequence data files).

This project works at the level of **grapheme clusters** (`package:characters`). For each cluster, the implementation looks at the **first scalar value**. If that scalar is listed in `kModifierBaseFirstScalars`, the cluster is treated as a candidate for inserting, replacing, or pairing with U+FE0F (emoji presentation) as needed.

## Listed base scalars

The set must contain only scalars that, in the current Unicode emoji data, **start a sequence that allows a Fitzpatrick modifier**. Do not add code points that are not emoji bases for skin tone, or variants that use a different mechanism (for example some mechanical or abstract symbols).

| Scalar | Unicode name (abridged) |
|--------|-------------------------|
| U+270A | RAISED FIST |
| U+270B | RAISED HAND |
| U+270C | VICTORY HAND |
| U+270D | WRITING HAND |
| U+1F44A | ONCOMING FIST |
| U+1F44C | OK HAND |
| U+1F44D | THUMBS UP |
| U+1F44E | THUMBS DOWN |
| U+1F448 | BACKHAND INDEX POINTING LEFT |
| U+1F449 | BACKHAND INDEX POINTING RIGHT |
| U+1F590 | HAND WITH FINGERS SPLAYED |
| U+1F596 | VULCAN SALUTE |
| U+1F918 | SIGN OF THE HORNS |
| U+1F919 | CALL ME HAND |
| U+1F91A | RAISED BACK OF HAND |
| U+1F91B | LEFT-FACING FIST |
| U+1F91C | RIGHT-FACING FIST |
| U+1F91E | HAND WITH INDEX AND MIDDLE FINGERS CROSSED |
| U+1F91F | LOVE-YOU GESTURE |
| U+1F4AA | FLEXED BICEPS |
| U+1F90C | PINCHED FINGERS |
| U+1F90F | PINCHING HAND |
| U+1FAF0 | HAND WITH INDEX FINGER AND THUMB CROSSED |
| U+1FAF1 | RIGHTWARDS HAND |
| U+1FAF2 | LEFTWARDS HAND |
| U+1FAF3 | RIGHTWARDS HAND |
| U+1FAF7 | LEFTWARDS PUSHING HAND |
| U+1FAF8 | RIGHTWARDS PUSHING HAND |

Names follow the [Unicode Character Database](https://www.unicode.org/ucd/) / emoji charts; wording may differ slightly from vendor labels.

## How to contribute a new base

1. Confirm in the official emoji data that the emoji you care about uses a **Fitzpatrick modifier** immediately after the base (or after emoji presentation selector where applicable), not a different encoding.
2. Add the **first scalar** of the cluster (one `int` literal in hex, e.g. `0x1F9XX`) to `kModifierBaseFirstScalars` in `emoji_skin_tone.dart`.
3. Keep the set sorted in a readable way (group related ranges if you add several).
4. Update this table so the next contributor sees the intent without opening the standard.
5. Run `dart analyze` and any widget or unit tests that touch skin tone.

## References

- [Unicode Technical Standard #51: Unicode Emoji](https://www.unicode.org/reports/tr51/)
- Published data: [emoji-sequences.txt](https://unicode.org/Public/emoji/latest/emoji-sequences.txt) and related files in the same directory
