import 'package:flutter/material.dart';

// ============================================================================
// TODO: AGENTE OMEGA - Este es un lienzo en blanco para la identidad visual.
// Eres libre de ser creativo. Define los colores, tipografías, y la estructura
// completa del [ThemeData] para hacer una UI espectacular.
// Utiliza estos colores iniciales provistos por el comando como punto de inicio:
//
// Primary Color: 6750A4
// Accent Color: CCC2DC
// ============================================================================

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      // Define el tema claro aquí...
      primaryColor: const Color(0xFF6750A4),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      // Define el tema oscuro aquí...
      brightness: Brightness.dark,
    );
  }
}
