// 📚 FolhaVirada - Validators
// Validadores de formulários e entrada de dados

import 'package:folhavirada/core/constants/app_strings.dart';

class Validators {
  /// Validar se o campo não está vazio
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.required;
    }
    return null;
  }

  /// Validar título do livro
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.titleRequired;
    }
    if (value.trim().length < 2) {
      return 'Título deve ter pelo menos 2 caracteres';
    }
    if (value.length > 200) {
      return 'Título deve ter no máximo 200 caracteres';
    }
    return null;
  }

  /// Validar autor do livro
  static String? validateAuthor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.authorRequired;
    }
    if (value.trim().length < 2) {
      return 'Nome do autor deve ter pelo menos 2 caracteres';
    }
    if (value.length > 100) {
      return 'Nome do autor deve ter no máximo 100 caracteres';
    }
    return null;
  }

  /// Validar ano de publicação
  static String? validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Ano é opcional
    }

    final year = int.tryParse(value);
    if (year == null) {
      return AppStrings.invalidYear;
    }

    final currentYear = DateTime.now().year;
    if (year < 1000 || year > currentYear + 1) {
      return 'Ano deve estar entre 1000 e ${currentYear + 1}';
    }

    return null;
  }

  /// Validar número de páginas
  static String? validatePages(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Páginas é opcional
    }

    final pages = int.tryParse(value);
    if (pages == null) {
      return AppStrings.invalidPages;
    }

    if (pages <= 0) {
      return 'Número de páginas deve ser maior que 0';
    }

    if (pages > 10000) {
      return 'Número de páginas deve ser menor que 10.000';
    }

    return null;
  }

  /// Validar página atual (progresso)
  static String? validateCurrentPage(String? value, int? totalPages) {
    if (value == null || value.trim().isEmpty) {
      return null; // Página atual é opcional
    }

    final currentPage = int.tryParse(value);
    if (currentPage == null) {
      return 'Página atual deve ser um número';
    }

    if (currentPage < 0) {
      return 'Página atual não pode ser negativa';
    }

    if (totalPages != null && currentPage > totalPages) {
      return 'Página atual não pode ser maior que o total';
    }

    return null;
  }

  /// Validar avaliação (0-5 estrelas)
  static String? validateRating(double? value) {
    if (value == null) {
      return null; // Avaliação é opcional
    }

    if (value < 0 || value > 5) {
      return AppStrings.invalidRating;
    }

    return null;
  }

  /// Validar ISBN (opcional)
  static String? validateISBN(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // ISBN é opcional
    }

    // Remove espaços, hífens e outros caracteres não numéricos
    final cleanISBN = value.replaceAll(RegExp(r'[^0-9X]'), '');

    // Verifica se é ISBN-10 ou ISBN-13
    if (cleanISBN.length == 10) {
      return _validateISBN10(cleanISBN);
    } else if (cleanISBN.length == 13) {
      return _validateISBN13(cleanISBN);
    } else {
      return 'ISBN deve ter 10 ou 13 dígitos';
    }
  }

  /// Validar URL (para capas de livros)
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URL é opcional
    }

    final urlPattern = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlPattern.hasMatch(value)) {
      return 'URL inválida';
    }

    return null;
  }

  /// Validar notas/descrição
  static String? validateNotes(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Notas são opcionais
    }

    if (value.length > 2000) {
      return 'Notas devem ter no máximo 2000 caracteres';
    }

    return null;
  }

  /// Validar data
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return null; // Data é opcional
    }

    final now = DateTime.now();
    final futureLimit = now.add(const Duration(days: 365));

    if (value.isAfter(futureLimit)) {
      return 'Data não pode ser muito distante no futuro';
    }

    // Verificar se a data não é muito antiga (antes de 1900)
    if (value.year < 1900) {
      return 'Data não pode ser anterior a 1900';
    }

    return null;
  }

  /// Validar período de leitura (data de início antes do fim)
  static String? validateReadingPeriod(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return null; // Datas são opcionais
    }

    if (startDate.isAfter(endDate)) {
      return 'Data de início deve ser anterior à data de término';
    }

    return null;
  }

  /// Combinar múltiplos validadores
  static String? combineValidators(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  // Métodos auxiliares privados

  static String? _validateISBN10(String isbn) {
    if (isbn.length != 10) return 'ISBN-10 deve ter 10 dígitos';

    int sum = 0;
    for (int i = 0; i < 9; i++) {
      final digit = int.tryParse(isbn[i]);
      if (digit == null) return 'ISBN-10 contém caracteres inválidos';
      sum += digit * (10 - i);
    }

    final checkDigit = isbn[9];
    final expectedCheckDigit = (11 - (sum % 11)) % 11;

    if (expectedCheckDigit == 10) {
      return checkDigit == 'X' ? null : 'ISBN-10 inválido';
    } else {
      final expectedStr = expectedCheckDigit.toString();
      return checkDigit == expectedStr ? null : 'ISBN-10 inválido';
    }
  }

  static String? _validateISBN13(String isbn) {
    if (isbn.length != 13) return 'ISBN-13 deve ter 13 dígitos';

    int sum = 0;
    for (int i = 0; i < 12; i++) {
      final digit = int.tryParse(isbn[i]);
      if (digit == null) return 'ISBN-13 contém caracteres inválidos';
      sum += digit * (i.isEven ? 1 : 3);
    }

    final checkDigit = int.tryParse(isbn[12]);
    if (checkDigit == null) return 'ISBN-13 contém caracteres inválidos';

    final expectedCheckDigit = (10 - (sum % 10)) % 10;
    return checkDigit == expectedCheckDigit ? null : 'ISBN-13 inválido';
  }
}
