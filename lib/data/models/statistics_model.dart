// 📚 FolhaVirada - Statistics Model
// Modelo de dados para estatísticas

import 'package:json_annotation/json_annotation.dart';
import 'package:folhavirada/domain/entities/statistics_entity.dart';

part 'statistics_model.g.dart';

@JsonSerializable()
class StatisticsModel {
  final int totalBooks;
  final int booksRead;
  final int booksReading;
  final int booksWantToRead;
  final int totalPages;
  final int pagesRead;
  final double averageRating;
  final int booksThisYear;
  final int booksThisMonth;
  final String? favoriteGenre;
  final double averageReadingDays;
  final Map<String, int> genreDistribution;
  final Map<String, int> monthlyReading;
  final Map<String, double> ratingDistribution;
  final String calculatedAt;

  const StatisticsModel({
    required this.totalBooks,
    required this.booksRead,
    required this.booksReading,
    required this.booksWantToRead,
    required this.totalPages,
    required this.pagesRead,
    required this.averageRating,
    required this.booksThisYear,
    required this.booksThisMonth,
    this.favoriteGenre,
    required this.averageReadingDays,
    required this.genreDistribution,
    required this.monthlyReading,
    required this.ratingDistribution,
    required this.calculatedAt,
  });

  /// Factory constructor para JSON
  factory StatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$StatisticsModelFromJson(json);

  /// Converter para JSON
  Map<String, dynamic> toJson() => _$StatisticsModelToJson(this);

  /// Factory constructor para banco de dados
  factory StatisticsModel.fromDatabase(Map<String, dynamic> map) {
    return StatisticsModel(
      totalBooks: map['total_books'] as int? ?? 0,
      booksRead: map['books_read'] as int? ?? 0,
      booksReading: map['books_reading'] as int? ?? 0,
      booksWantToRead: map['books_want_to_read'] as int? ?? 0,
      totalPages: map['total_pages'] as int? ?? 0,
      pagesRead: map['pages_read'] as int? ?? 0,
      averageRating: (map['average_rating'] as num?)?.toDouble() ?? 0.0,
      booksThisYear: map['books_this_year'] as int? ?? 0,
      booksThisMonth: map['books_this_month'] as int? ?? 0,
      favoriteGenre: map['favorite_genre'] as String?,
      averageReadingDays: (map['average_reading_days'] as num?)?.toDouble() ?? 0.0,
      genreDistribution: _parseIntMap(map['genre_distribution'] as String?),
      monthlyReading: _parseIntMap(map['monthly_reading'] as String?),
      ratingDistribution: _parseDoubleMap(map['rating_distribution'] as String?),
      calculatedAt: map['calculated_at'] as String,
    );
  }

  /// Converter para mapa do banco de dados
  Map<String, dynamic> toDatabase() {
    return {
      'total_books': totalBooks,
      'books_read': booksRead,
      'books_reading': booksReading,
      'books_want_to_read': booksWantToRead,
      'total_pages': totalPages,
      'pages_read': pagesRead,
      'average_rating': averageRating,
      'books_this_year': booksThisYear,
      'books_this_month': booksThisMonth,
      'favorite_genre': favoriteGenre,
      'average_reading_days': averageReadingDays,
      'genre_distribution': _mapToString(genreDistribution),
      'monthly_reading': _mapToString(monthlyReading),
      'rating_distribution': _mapToString(ratingDistribution),
      'calculated_at': calculatedAt,
    };
  }

  /// Factory constructor vazio (para inicialização)
  factory StatisticsModel.empty() {
    return StatisticsModel(
      totalBooks: 0,
      booksRead: 0,
      booksReading: 0,
      booksWantToRead: 0,
      totalPages: 0,
      pagesRead: 0,
      averageRating: 0.0,
      booksThisYear: 0,
      booksThisMonth: 0,
      favoriteGenre: null,
      averageReadingDays: 0.0,
      genreDistribution: {},
      monthlyReading: {},
      ratingDistribution: {},
      calculatedAt: DateTime.now().toIso8601String(),
    );
  }

  /// Converter para entidade do domínio
  StatisticsEntity toEntity() {
    return StatisticsEntity(
      totalBooks: totalBooks,
      booksRead: booksRead,
      booksReading: booksReading,
      booksWantToRead: booksWantToRead,
      totalPages: totalPages,
      pagesRead: pagesRead,
      averageRating: averageRating,
      booksThisYear: booksThisYear,
      booksThisMonth: booksThisMonth,
      favoriteGenre: favoriteGenre,
      averageReadingDays: averageReadingDays,
      genreDistribution: genreDistribution,
      monthlyReading: monthlyReading,
      ratingDistribution: ratingDistribution,
      calculatedAt: DateTime.parse(calculatedAt),
    );
  }

  /// Factory constructor da entidade do domínio
  factory StatisticsModel.fromEntity(StatisticsEntity entity) {
    return StatisticsModel(
      totalBooks: entity.totalBooks,
      booksRead: entity.booksRead,
      booksReading: entity.booksReading,
      booksWantToRead: entity.booksWantToRead,
      totalPages: entity.totalPages,
      pagesRead: entity.pagesRead,
      averageRating: entity.averageRating,
      booksThisYear: entity.booksThisYear,
      booksThisMonth: entity.booksThisMonth,
      favoriteGenre: entity.favoriteGenre,
      averageReadingDays: entity.averageReadingDays,
      genreDistribution: entity.genreDistribution,
      monthlyReading: entity.monthlyReading,
      ratingDistribution: entity.ratingDistribution,
      calculatedAt: entity.calculatedAt.toIso8601String(),
    );
  }

  /// Criar cópia com alterações
  StatisticsModel copyWith({
    int? totalBooks,
    int? booksRead,
    int? booksReading,
    int? booksWantToRead,
    int? totalPages,
    int? pagesRead,
    double? averageRating,
    int? booksThisYear,
    int? booksThisMonth,
    String? favoriteGenre,
    double? averageReadingDays,
    Map<String, int>? genreDistribution,
    Map<String, int>? monthlyReading,
    Map<String, double>? ratingDistribution,
    String? calculatedAt,
  }) {
    return StatisticsModel(
      totalBooks: totalBooks ?? this.totalBooks,
      booksRead: booksRead ?? this.booksRead,
      booksReading: booksReading ?? this.booksReading,
      booksWantToRead: booksWantToRead ?? this.booksWantToRead,
      totalPages: totalPages ?? this.totalPages,
      pagesRead: pagesRead ?? this.pagesRead,
      averageRating: averageRating ?? this.averageRating,
      booksThisYear: booksThisYear ?? this.booksThisYear,
      booksThisMonth: booksThisMonth ?? this.booksThisMonth,
      favoriteGenre: favoriteGenre ?? this.favoriteGenre,
      averageReadingDays: averageReadingDays ?? this.averageReadingDays,
      genreDistribution: genreDistribution ?? this.genreDistribution,
      monthlyReading: monthlyReading ?? this.monthlyReading,
      ratingDistribution: ratingDistribution ?? this.ratingDistribution,
      calculatedAt: calculatedAt ?? this.calculatedAt,
    );
  }

  /// Métodos auxiliares

  /// Calcular progresso em relação à meta anual
  double calculateYearlyProgress(int goal) {
    if (goal == 0) return 0.0;
    return (booksThisYear / goal * 100).clamp(0.0, 100.0);
  }

  /// Verificar se tem livros
  bool get hasBooks => totalBooks > 0;

  /// Verificar se está lendo algum livro
  bool get isCurrentlyReading => booksReading > 0;

  /// Obter porcentagem de livros lidos
  double get readPercentage {
    if (totalBooks == 0) return 0.0;
    return (booksRead / totalBooks * 100);
  }

  /// Obter porcentagem de páginas lidas
  double get pagesReadPercentage {
    if (totalPages == 0) return 0.0;
    return (pagesRead / totalPages * 100);
  }

  /// Obter gênero mais popular (com mais livros)
  String? get mostPopularGenre {
    if (genreDistribution.isEmpty) return null;
    
    var maxCount = 0;
    String? mostPopular;
    
    genreDistribution.forEach((genre, count) {
      if (count > maxCount) {
        maxCount = count;
        mostPopular = genre;
      }
    });
    
    return mostPopular;
  }

  /// Obter mês com mais leituras
  String? get mostProductiveMonth {
    if (monthlyReading.isEmpty) return null;
    
    var maxCount = 0;
    String? mostProductive;
    
    monthlyReading.forEach((month, count) {
      if (count > maxCount) {
        maxCount = count;
        mostProductive = month;
      }
    });
    
    return mostProductive;
  }

  /// Métodos auxiliares estáticos para serialização
  static Map<String, int> _parseIntMap(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      // Parse simplified: "key1:value1,key2:value2"
      final map = <String, int>{};
      final parts = jsonString.split(',');
      for (final part in parts) {
        final keyValue = part.split(':');
        if (keyValue.length == 2) {
          map[keyValue[0]] = int.tryParse(keyValue[1]) ?? 0;
        }
      }
      return map;
    } catch (e) {
      return {};
    }
  }

  static Map<String, double> _parseDoubleMap(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      final map = <String, double>{};
      final parts = jsonString.split(',');
      for (final part in parts) {
        final keyValue = part.split(':');
        if (keyValue.length == 2) {
          map[keyValue[0]] = double.tryParse(keyValue[1]) ?? 0.0;
        }
      }
      return map;
    } catch (e) {
      return {};
    }
  }

  static String _mapToString(Map<String, dynamic> map) {
    if (map.isEmpty) return '';
    return map.entries.map((e) => '${e.key}:${e.value}').join(',');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticsModel &&
          runtimeType == other.runtimeType &&
          totalBooks == other.totalBooks &&
          booksRead == other.booksRead &&
          calculatedAt == other.calculatedAt;

  @override
  int get hashCode => totalBooks.hashCode ^ booksRead.hashCode ^ calculatedAt.hashCode;

  @override
  String toString() {
    return 'StatisticsModel{totalBooks: $totalBooks, booksRead: $booksRead, booksReading: $booksReading}';
  }
}
