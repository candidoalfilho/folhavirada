// 📚 FolhaVirada - Statistics Entity
// Entidade de domínio para estatísticas

class StatisticsEntity {
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
  final DateTime calculatedAt;

  const StatisticsEntity({
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

  /// Factory constructor vazio (para inicialização)
  factory StatisticsEntity.empty() {
    return StatisticsEntity(
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
      calculatedAt: DateTime.now(),
    );
  }

  /// Criar cópia com alterações
  StatisticsEntity copyWith({
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
    DateTime? calculatedAt,
  }) {
    return StatisticsEntity(
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

  /// Verificar se tem livros
  bool get hasBooks => totalBooks > 0;

  /// Verificar se está lendo algum livro
  bool get isCurrentlyReading => booksReading > 0;

  /// Obter porcentagem de livros lidos
  double get readPercentage {
    if (totalBooks == 0) return 0.0;
    return (booksRead / totalBooks * 100);
  }

  /// Obter porcentagem de livros em andamento
  double get readingPercentage {
    if (totalBooks == 0) return 0.0;
    return (booksReading / totalBooks * 100);
  }

  /// Obter porcentagem de livros que quer ler
  double get wantToReadPercentage {
    if (totalBooks == 0) return 0.0;
    return (booksWantToRead / totalBooks * 100);
  }

  /// Obter porcentagem de páginas lidas
  double get pagesReadPercentage {
    if (totalPages == 0) return 0.0;
    return (pagesRead / totalPages * 100);
  }

  /// Calcular progresso em relação à meta anual
  double calculateYearlyProgress(int goal) {
    if (goal == 0) return 0.0;
    return (booksThisYear / goal * 100).clamp(0.0, 100.0);
  }

  /// Verificar se atingiu a meta anual
  bool hasAchievedYearlyGoal(int goal) {
    return booksThisYear >= goal;
  }

  /// Calcular livros restantes para atingir a meta
  int booksRemainingForGoal(int goal) {
    return (goal - booksThisYear).clamp(0, goal);
  }

  /// Obter média de livros por mês este ano
  double get averageBooksPerMonth {
    final currentMonth = DateTime.now().month;
    if (currentMonth == 0) return 0.0;
    return booksThisYear / currentMonth;
  }

  /// Estimar livros que conseguirá ler este ano baseado no ritmo atual
  int get estimatedBooksThisYear {
    final averagePerMonth = averageBooksPerMonth;
    if (averagePerMonth == 0) return booksThisYear;
    return (averagePerMonth * 12).round();
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

  /// Obter avaliação mais comum
  double? get mostCommonRating {
    if (ratingDistribution.isEmpty) return null;
    
    var maxCount = 0.0;
    double? mostCommon;
    
    ratingDistribution.forEach((rating, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommon = double.tryParse(rating);
      }
    });
    
    return mostCommon;
  }

  /// Verificar se é um leitor ativo (leu pelo menos 1 livro nos últimos 30 dias)
  bool get isActiveReader => booksThisMonth > 0;

  /// Obter velocidade de leitura (páginas por dia)
  double get readingSpeed {
    if (averageReadingDays == 0) return 0.0;
    final averagePages = booksRead > 0 ? pagesRead / booksRead : 0;
    return averagePages / averageReadingDays;
  }

  /// Verificar se é um leitor rápido (mais de 50 páginas por dia)
  bool get isFastReader => readingSpeed > 50;

  /// Verificar se é um leitor lento (menos de 20 páginas por dia)
  bool get isSlowReader => readingSpeed > 0 && readingSpeed < 20;

  /// Obter tempo estimado para ler um livro de X páginas
  int estimatedDaysToRead(int pages) {
    if (readingSpeed == 0) return 0;
    return (pages / readingSpeed).ceil();
  }

  /// Obter diversidade de gêneros (número de gêneros diferentes lidos)
  int get genreDiversity => genreDistribution.keys.length;

  /// Verificar se tem preferência por gênero específico (mais de 40% dos livros)
  bool get hasGenrePreference {
    if (totalBooks == 0 || genreDistribution.isEmpty) return false;
    
    final maxGenreCount = genreDistribution.values.reduce((a, b) => a > b ? a : b);
    return (maxGenreCount / totalBooks) > 0.4;
  }

  /// Obter consistência de leitura (variação na leitura mensal)
  double get readingConsistency {
    if (monthlyReading.isEmpty || monthlyReading.length < 2) return 0.0;
    
    final values = monthlyReading.values.toList();
    final average = values.reduce((a, b) => a + b) / values.length;
    
    double variance = 0;
    for (final value in values) {
      variance += (value - average) * (value - average);
    }
    variance /= values.length;
    
    final standardDeviation = variance > 0 ? variance : 0;
    return average > 0 ? (1 - (standardDeviation / average)).clamp(0.0, 1.0) : 0.0;
  }

  /// Verificar se as estatísticas estão atualizadas (calculadas nas últimas 24h)
  bool get isUpToDate {
    final twentyFourHoursAgo = DateTime.now().subtract(const Duration(hours: 24));
    return calculatedAt.isAfter(twentyFourHoursAgo);
  }

  /// Obter rank de leitor baseado no número de livros lidos
  String get readerRank {
    if (booksRead >= 100) return 'Bibliófilo';
    if (booksRead >= 50) return 'Leitor Experiente';
    if (booksRead >= 25) return 'Leitor Ativo';
    if (booksRead >= 10) return 'Leitor Regular';
    if (booksRead >= 5) return 'Leitor Iniciante';
    if (booksRead >= 1) return 'Novo Leitor';
    return 'Aspirante a Leitor';
  }

  /// Obter insights interessantes
  List<String> get insights {
    final insights = <String>[];
    
    if (hasBooks) {
      insights.add('Você tem $totalBooks livros na sua biblioteca');
    }
    
    if (isActiveReader) {
      insights.add('Você leu $booksThisMonth livros este mês - continue assim!');
    }
    
    if (mostPopularGenre != null) {
      insights.add('Seu gênero favorito é $mostPopularGenre');
    }
    
    if (isFastReader) {
      insights.add('Você é um leitor rápido - ${readingSpeed.toStringAsFixed(1)} páginas por dia!');
    }
    
    if (genreDiversity >= 5) {
      insights.add('Você tem gostos diversificados - já leu $genreDiversity gêneros diferentes');
    }
    
    if (averageRating >= 4.0) {
      insights.add('Você tem bom gosto - avaliação média de ${averageRating.toStringAsFixed(1)} estrelas');
    }
    
    return insights;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticsEntity &&
          runtimeType == other.runtimeType &&
          totalBooks == other.totalBooks &&
          booksRead == other.booksRead &&
          calculatedAt == other.calculatedAt;

  @override
  int get hashCode => totalBooks.hashCode ^ booksRead.hashCode ^ calculatedAt.hashCode;

  @override
  String toString() {
    return 'StatisticsEntity{totalBooks: $totalBooks, booksRead: $booksRead, booksReading: $booksReading}';
  }
}
