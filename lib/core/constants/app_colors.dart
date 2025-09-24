// 📚 FolhaVirada - App Colors
// Sistema de cores para temas claro e escuro

import 'package:flutter/material.dart';

class AppColors {
  // Cores primárias - baseadas em tons de azul/verde para transmitir conhecimento e crescimento
  static const Color primary = Color(0xFF2E7D32); // Verde escuro
  static const Color primaryLight = Color(0xFF60AD5E);
  static const Color primaryDark = Color(0xFF005005);

  // Cores secundárias - tons de laranja para dar energia e motivação
  static const Color secondary = Color(0xFFFF6F00);
  static const Color secondaryLight = Color(0xFFFF9F40);
  static const Color secondaryDark = Color(0xFFC43E00);

  // Cores de superfície
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);

  // Cores de texto
  static const Color textPrimary = Color(0xFF212121);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textHintDark = Color(0xFF6E6E6E);

  // Cores de status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Cores específicas para book status
  static const Color wantToReadColor = Color(0xFF9C27B0); // Roxo
  static const Color readingColor = Color(0xFF2196F3);    // Azul
  static const Color readColor = Color(0xFF4CAF50);       // Verde

  // Cores de rating
  static const Color starFilled = Color(0xFFFFD700);      // Dourado
  static const Color starEmpty = Color(0xFFE0E0E0);       // Cinza claro

  // Cores de componentes
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF2A2A2A);
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF3A3A3A);

  // Cores de sombra
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x3A000000);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient statsGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Métodos auxiliares para obter cores baseadas no status do livro
  static Color getStatusColor(String status) {
    switch (status) {
      case 'want_to_read':
        return wantToReadColor;
      case 'reading':
        return readingColor;
      case 'read':
        return readColor;
      default:
        return textSecondary;
    }
  }

  // Método para obter cor com opacidade
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  // Paleta de cores para gráficos
  static const List<Color> chartColors = [
    Color(0xFF2E7D32),
    Color(0xFFFF6F00),
    Color(0xFF2196F3),
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
    Color(0xFF00BCD4),
    Color(0xFF8BC34A),
    Color(0xFFFF5722),
    Color(0xFF607D8B),
    Color(0xFFFFC107),
  ];
}
