// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get catalogLoadError => 'No se pudieron cargar los kaomojis.';

  @override
  String get splashSubtitle => 'Kaomojis para tu día';

  @override
  String get retry => 'Reintentar';

  @override
  String get emotionsTab => 'Emociones';

  @override
  String get creatorTab => 'Creador';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeSubtitle => 'Selecciona apariencia de la app';

  @override
  String get themeAutomatic => 'Automático';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get licensesTitle => 'Licencias';

  @override
  String get licensesSubtitle => 'Licencias de código abierto y fuentes';

  @override
  String get exportTxtTooltip => 'Exportar a .txt';

  @override
  String get exportFavorites => 'Exportar favoritos (.txt)';

  @override
  String get exportSaved => 'Exportar guardados (.txt)';

  @override
  String get exportFavoritesFileNameBase => 'kaouwu_favoritos';

  @override
  String get exportSavedFileNameBase => 'kaouwu_guardados';

  @override
  String get exportFavoritesSubject => 'Kaouwu — favoritos';

  @override
  String get exportSavedSubject => 'Kaouwu — guardados';

  @override
  String get settingsTooltip => 'Ajustes';

  @override
  String get searchKaomojiHint => 'Buscar kaomoji';

  @override
  String emptyCategoryMessage(Object categoryLabel) {
    return 'Todavía no hay kaomojis en $categoryLabel.';
  }

  @override
  String notFoundCategoryMessage(Object categoryLabel) {
    return 'No encontramos kaomojis en $categoryLabel.';
  }

  @override
  String get deleteKaomojiTitle => 'Eliminar kaomoji';

  @override
  String deleteKaomojiQuestion(Object kaomoji) {
    return '¿Quieres eliminar $kaomoji de guardados?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get exportNoItems => 'No hay kaomojis que exportar';

  @override
  String get exportError => 'No se pudo exportar el archivo';

  @override
  String get creatorTitle => 'Creador de Kaomojis';

  @override
  String get skinToneTitle => 'Tono de piel (emojis)';

  @override
  String get skinToneDescription =>
      'Se aplica a manos y brazos con tono, en vista previa y al copiar o guardar.';

  @override
  String get randomMixTooltip => 'Mezcla aleatoria';

  @override
  String get previewTitle => 'Vista previa';

  @override
  String get copy => 'Copiar';

  @override
  String get save => 'Guardar';

  @override
  String get copiedToClipboard => 'Kaomoji copiado al portapapeles';

  @override
  String get savedInApp => 'Kaomoji guardado en la app';

  @override
  String get decorationsTitle => 'Decoraciones (varias)';

  @override
  String get decorationsDescription =>
      'Adelante: al inicio del kaomoji (izquierda). Atrás: al final (derecha). Toca la tira para añadir piezas; puedes combinar varias.';

  @override
  String get before => 'Adelante';

  @override
  String get after => 'Atrás';

  @override
  String get startBefore => 'Inicio (Adelante)';

  @override
  String get endAfter => 'Final (Atrás)';

  @override
  String appendOnSideLabel(Object side) {
    return 'Toca para añadir (lado: $side)';
  }

  @override
  String get leftArm => 'Brazo izquierdo';

  @override
  String get faceExpression => 'Cara / expresión';

  @override
  String get rightArm => 'Brazo derecho';

  @override
  String get clear => 'Vaciar';

  @override
  String get noneTapBelow => '(ninguna — toca la tira abajo para añadir)';

  @override
  String get savedSection => 'Tus guardados';

  @override
  String get exportTxt => 'Exportar .txt';

  @override
  String get clearSavedTitle => 'Borrar guardados';

  @override
  String get clearSavedQuestion => 'Se borrarán todos tus kaomojis guardados.';

  @override
  String get clearAll => 'Borrar todo';

  @override
  String get savedDeleted => 'Guardados eliminados';

  @override
  String get noSavedYet => 'Aún no tienes kaomojis guardados.';

  @override
  String get noLicensesRegistered => 'No hay licencias registradas.';

  @override
  String get licensesLegalese =>
      'Esta aplicación incluye software de terceros y fuentes tipográficas distribuidas bajo licencias de código abierto. A continuación se listan las licencias registradas por el motor de Flutter y los paquetes de la app.';
}
