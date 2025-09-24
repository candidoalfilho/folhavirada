// 📚 FolhaVirada - Date Helper
// Utilitários para manipulação de datas

import 'package:intl/intl.dart';

class DateHelper {
  // Formatadores de data
  static final DateFormat _displayFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy', 'pt_BR');
  static final DateFormat _shortMonthFormat = DateFormat('MMM yyyy', 'pt_BR');
  static final DateFormat _dayMonthFormat = DateFormat('dd MMM', 'pt_BR');
  static final DateFormat _storageFormat = DateFormat('yyyy-MM-dd');

  /// Formatar data para exibição (dd/MM/yyyy)
  static String formatDisplayDate(DateTime date) {
    return _displayFormat.format(date);
  }

  /// Formatar data para exibição compacta (dd MMM)
  static String formatCompactDate(DateTime date) {
    return _dayMonthFormat.format(date);
  }

  /// Formatar mês e ano (Janeiro 2024)
  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  /// Formatar mês e ano compacto (Jan 2024)
  static String formatShortMonthYear(DateTime date) {
    return _shortMonthFormat.format(date);
  }

  /// Formatar data para armazenamento (yyyy-MM-dd)
  static String formatStorageDate(DateTime date) {
    return _storageFormat.format(date);
  }

  /// Converter string de armazenamento para DateTime
  static DateTime? parseStorageDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Verificar se duas datas são do mesmo dia
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Verificar se duas datas são do mesmo mês
  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  /// Verificar se duas datas são do mesmo ano
  static bool isSameYear(DateTime date1, DateTime date2) {
    return date1.year == date2.year;
  }

  /// Calcular dias entre duas datas
  static int daysBetween(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  /// Calcular tempo de leitura em dias
  static int calculateReadingDays(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return 0;
    return daysBetween(startDate, endDate) + 1;
  }

  /// Obter primeiro dia do mês
  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Obter último dia do mês
  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Obter primeiro dia do ano
  static DateTime getFirstDayOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Obter último dia do ano
  static DateTime getLastDayOfYear(DateTime date) {
    return DateTime(date.year, 12, 31);
  }

  /// Formatação relativa (hoje, ontem, etc.)
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) {
      return 'Hoje';
    } else if (difference == 1) {
      return 'Ontem';
    } else if (difference == -1) {
      return 'Amanhã';
    } else if (difference > 1 && difference <= 7) {
      return '$difference dias atrás';
    } else if (difference < -1 && difference >= -7) {
      return 'Em ${-difference} dias';
    } else {
      return formatDisplayDate(date);
    }
  }

  /// Verificar se é ano bissexto
  static bool isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  /// Obter lista de anos para seleção
  static List<int> getYearsList({int? startYear, int? endYear}) {
    final currentYear = DateTime.now().year;
    final start = startYear ?? 1900;
    final end = endYear ?? currentYear + 1;
    
    return List.generate(end - start + 1, (index) => start + index)
        .reversed
        .toList();
  }

  /// Validar se uma data é válida
  static bool isValidDate(int year, int month, int day) {
    try {
      final date = DateTime(year, month, day);
      return date.year == year && date.month == month && date.day == day;
    } catch (e) {
      return false;
    }
  }

  /// Obter idade em anos baseada na data de publicação
  static int getBookAge(DateTime publishDate) {
    final now = DateTime.now();
    return now.year - publishDate.year;
  }

  /// Formatação personalizada para estatísticas
  static String formatStatDate(DateTime date) {
    final now = DateTime.now();
    
    if (isSameYear(date, now)) {
      if (isSameMonth(date, now)) {
        return formatCompactDate(date);
      } else {
        return formatShortMonthYear(date);
      }
    } else {
      return '${date.year}';
    }
  }
}
