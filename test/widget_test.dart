import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toolbox_jfr/main.dart';
import 'package:toolbox_jfr/screens/about_screen.dart';
import 'package:toolbox_jfr/screens/pokemon_screen.dart';

/// Usa una superficie más alta que el tamaño de test por defecto (800x600)
/// para que el grid completo de herramientas quede visible sin necesidad
/// de hacer scroll manual antes de interactuar con él.
Future<void> pumpWithTallSurface(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(const MyApp());
}

void main() {
  testWidgets('HomeScreen muestra el titulo y las 6 herramientas', (tester) async {
    await pumpWithTallSurface(tester);

    expect(find.text('Toolbox App'), findsOneWidget);
    expect(find.text('Predecir Género'), findsOneWidget);
    expect(find.text('Predecir Edad'), findsOneWidget);
    expect(find.text('Universidades'), findsOneWidget);
    expect(find.text('Clima en RD'), findsOneWidget);
    expect(find.text('Pokémon'), findsOneWidget);
    expect(find.text('Noticias'), findsOneWidget);
  });

  testWidgets('Tocar "Acerca de" navega a AboutScreen', (tester) async {
    await pumpWithTallSurface(tester);

    await tester.tap(find.text('Acerca de'));
    await tester.pumpAndSettle();

    expect(find.byType(AboutScreen), findsOneWidget);
    expect(find.text('Josue Fondeur Román'), findsOneWidget);
  });

  testWidgets('Tocar la tarjeta de Pokémon navega a PokemonScreen', (tester) async {
    await pumpWithTallSurface(tester);

    await tester.tap(find.text('Pokémon'));
    await tester.pumpAndSettle();

    expect(find.byType(PokemonScreen), findsOneWidget);
  });
}
