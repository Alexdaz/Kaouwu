import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';

export 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(_bundledNotoLicenses);
  runApp(const KaouwuApp());
}

Stream<LicenseEntry> _bundledNotoLicenses() async* {
  try {
    final text = await rootBundle.loadString('assets/fonts/Noto-OFL.txt');
    yield LicenseEntryWithLineBreaks(
      <String>[
        'Bundled Noto fonts (Noto Sans, Noto Sans JP, Noto Symbols, etc.)',
      ],
      text,
    );
  } catch (_) {
    // Do not block startup if the asset is missing.
  }
}
