import 'package:flutter/material.dart';

/// Paleta y tema central de la aplicacion Toolbox App.
class AppTheme {
  static const Color primary = Color(0xFF2E5C8A);
  static const Color primaryLight = Color(0xFFDCE9F5);

  static const Color masculino = Color(0xFF4A90E2);
  static const Color masculinoFondo = Color(0xFFEAF2FB);

  static const Color femenino = Color(0xFFE91E8C);
  static const Color femeninoFondo = Color(0xFFFCE9F4);

  static const Color joven = Color(0xFF43A047);
  static const Color adulto = Color(0xFFFB8C00);
  static const Color anciano = Color(0xFF6D6875);

  static const Color clima = Color(0xFF5FB0E5);
  static const Color pokemonAmarillo = Color(0xFFFFCB05);
  static const Color pokemonAzul = Color(0xFF3B5BA5);
  static const Color universidades = Color(0xFF7B2D26);
  static const Color noticias = Color(0xFF21759B);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primary,
      scaffoldBackgroundColor: const Color(0xFFF6F8FB),
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
