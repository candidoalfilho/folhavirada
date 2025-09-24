// 📚 FolhaVirada - App Utils
// Utilitários gerais da aplicação

import 'dart:io';
import 'dart:math';
import 'dart:async' as dart_async;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folhavirada/core/constants/app_constants.dart';
import 'package:folhavirada/core/constants/app_strings.dart';

class AppUtils {
  /// Gerar cores aleatórias para gráficos
  static Color generateRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  /// Obter cor baseada no status do livro
  static Color getStatusColor(String status) {
    switch (status) {
      case 'want_to_read':
        return const Color(0xFF9C27B0); // Roxo
      case 'reading':
        return const Color(0xFF2196F3); // Azul
      case 'read':
        return const Color(0xFF4CAF50); // Verde
      default:
        return const Color(0xFF757575); // Cinza
    }
  }

  /// Obter ícone baseado no status do livro
  static IconData getStatusIcon(String status) {
    switch (status) {
      case 'want_to_read':
        return Icons.bookmark_border;
      case 'reading':
        return Icons.menu_book;
      case 'read':
        return Icons.check_circle;
      default:
        return Icons.book;
    }
  }

  /// Formatar número com separadores de milhares
  static String formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  /// Calcular porcentagem de progresso
  static double calculateProgress(int currentPage, int totalPages) {
    if (totalPages == 0) return 0.0;
    return (currentPage / totalPages * 100).clamp(0.0, 100.0);
  }

  /// Formatar porcentagem
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  /// Truncar texto com reticências
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Capitalizar primeira letra de cada palavra
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Limpar e formatar string
  static String cleanString(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Verificar se string é nula ou vazia
  static bool isNullOrEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }

  /// Gerar ID único baseado em timestamp
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Vibração háptica suave
  static void lightHaptic() {
    HapticFeedback.lightImpact();
  }

  /// Vibração háptica média
  static void mediumHaptic() {
    HapticFeedback.mediumImpact();
  }

  /// Vibração háptica forte
  static void heavyHaptic() {
    HapticFeedback.heavyImpact();
  }

  /// Mostrar SnackBar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppConstants.spacing),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    );
  }

  /// Mostrar dialog de confirmação
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = AppStrings.yes,
    String cancelText = AppStrings.no,
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: confirmColor,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Verificar conexão com internet
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Obter plataforma atual
  static String getCurrentPlatform() {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Converter bytes para formato legível
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Validar se string é um número
  static bool isNumeric(String? str) {
    if (str == null || str.isEmpty) return false;
    return double.tryParse(str) != null;
  }

  /// Obter cor do texto baseada na cor de fundo
  static Color getTextColor(Color backgroundColor) {
    // Calcular luminância da cor de fundo
    final luminance = backgroundColor.computeLuminance();
    // Retornar branco para fundos escuros, preto para fundos claros
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Debounce para evitar múltiplas execuções
  static AppTimer? _debounceTimer;
  static void debounce(VoidCallback action, {Duration delay = const Duration(milliseconds: 500)}) {
    AppTimer.cancelStatic();
    _debounceTimer = AppTimer(delay, action);
  }

  /// Throttle para limitar execuções
  static DateTime? _lastExecution;
  static void throttle(VoidCallback action, {Duration interval = const Duration(milliseconds: 500)}) {
    final now = DateTime.now();
    if (_lastExecution == null || now.difference(_lastExecution!) >= interval) {
      _lastExecution = now;
      action();
    }
  }

  /// Gerar gradiente baseado em cores
  static LinearGradient createGradient(Color color) {
    return LinearGradient(
      colors: [
        color,
        color.withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Animar transição entre telas
  static PageRouteBuilder createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: AppConstants.animationDuration,
    );
  }
}

/// Timer personalizado para debounce
class AppTimer {
  static dart_async.Timer? _staticTimer;
  dart_async.Timer? _instanceTimer;
  
  static void cancelStatic() {
    _staticTimer?.cancel();
  }
  
  AppTimer(Duration duration, VoidCallback callback) {
    _instanceTimer = dart_async.Timer(duration, callback);
    _staticTimer = _instanceTimer;
  }
  
  void cancel() {
    _instanceTimer?.cancel();
  }
}
