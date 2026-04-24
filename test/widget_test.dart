import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kaouwu/core/constants/app_constants.dart';
import 'package:kaouwu/main.dart';

void main() {
  testWidgets('Muestra las secciones principales', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const KaouwuApp());
    await tester.pump(AppStyle.widgetTestWarmup);
    await tester.pumpAndSettle();

    expect(find.text('Kaouwu'), findsOneWidget);
    expect(find.text('Emociones'), findsOneWidget);
    expect(find.text('Creador'), findsOneWidget);
  });
}
