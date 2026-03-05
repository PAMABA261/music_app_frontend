import 'package:flutter_test/flutter_test.dart';
import 'package:music_frontend/main.dart'; // 👈 Importa tu archivo main

void main() {
  testWidgets('Carga inicial de la app', (WidgetTester tester) async {
    // 1. Le decimos que cargue TU aplicación real (MusicApp, no MyApp)
    await tester.pumpWidget(const MusicApp());

    // 2. Comprobamos que al menos aparece el texto "Piano" en la pantalla
    expect(find.text('Piano'), findsWidgets);
  });
}
