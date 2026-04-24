import 'package:flutter/widgets.dart';

import 'emotion_category_ids.dart';

const Map<String, String> emotionLabelsEs = {
  EmotionCategoryIds.favorites: 'Favoritos',
  EmotionCategoryIds.saved: 'Guardados',
  'happy': 'Feliz',
  'sad': 'Triste',
  'angry': 'Enojado',
  'love': 'Amor',
  'surprised': 'Sorpresa',
  'shy': 'Tímido',
  'sleepy': 'Dormido',
  'confused': 'Confundido',
  'nervous': 'Nervioso',
  'embarrassed': 'Apenado',
  'proud': 'Orgulloso',
  'greeting': 'Saludando',
  'celebrating': 'Celebrando',
};

const Map<String, String> emotionLabelsEn = {
  EmotionCategoryIds.favorites: 'Favorites',
  EmotionCategoryIds.saved: 'Saved',
  'happy': 'Happy',
  'sad': 'Sad',
  'angry': 'Angry',
  'love': 'Love',
  'surprised': 'Surprised',
  'shy': 'Shy',
  'sleepy': 'Sleepy',
  'confused': 'Confused',
  'nervous': 'Nervous',
  'embarrassed': 'Embarrassed',
  'proud': 'Proud',
  'greeting': 'Greeting',
  'celebrating': 'Celebrating',
};

String emotionLabel(BuildContext context, String key) {
  final languageCode = Localizations.localeOf(context).languageCode;
  if (languageCode == 'es') {
    return emotionLabelsEs[key] ?? key;
  }
  return emotionLabelsEn[key] ?? key;
}
