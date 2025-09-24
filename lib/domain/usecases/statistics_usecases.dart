// 📚 FolhaVirada - Statistics Use Cases
// Casos de uso para operações com estatísticas

import 'package:injectable/injectable.dart';
import 'package:folhavirada/domain/entities/statistics_entity.dart';
import 'package:folhavirada/domain/repositories/statistics_repository.dart';
import 'package:folhavirada/domain/usecases/book_usecases.dart';

// Parâmetros para diferentes use cases
class GetStatisticsByPeriodParams {
  final DateTime start;
  final DateTime end;

  const GetStatisticsByPeriodParams({
    required this.start,
    required this.end,
  });
}

// Use Cases

@injectable
class GetStatisticsUseCase implements UseCase<StatisticsEntity, void> {
  final StatisticsRepository _repository;

  GetStatisticsUseCase(this._repository);

  @override
  Future<StatisticsEntity> call(void params) async {
    // Tentar obter estatísticas em cache primeiro
    final cachedStats = await _repository.getCachedStatistics();
    
    // Verificar se precisa recalcular
    final needsRecalculation = await _repository.needsRecalculation();
    
    if (cachedStats != null && !needsRecalculation) {
      return cachedStats;
    }

    // Calcular novas estatísticas
    final newStats = await _repository.calculateStatistics();
    
    // Salvar em cache
    await _repository.cacheStatistics(newStats);
    
    return newStats;
  }
}

@injectable
class ForceRecalculateStatisticsUseCase implements UseCase<StatisticsEntity, void> {
  final StatisticsRepository _repository;

  ForceRecalculateStatisticsUseCase(this._repository);

  @override
  Future<StatisticsEntity> call(void params) async {
    // Limpar cache existente
    await _repository.clearStatisticsCache();
    
    // Calcular novas estatísticas
    final newStats = await _repository.calculateStatistics();
    
    // Salvar em cache
    await _repository.cacheStatistics(newStats);
    
    return newStats;
  }
}

@injectable
class GetStatisticsByPeriodUseCase implements UseCase<StatisticsEntity, GetStatisticsByPeriodParams> {
  final StatisticsRepository _repository;

  GetStatisticsByPeriodUseCase(this._repository);

  @override
  Future<StatisticsEntity> call(GetStatisticsByPeriodParams params) async {
    // Validar período
    if (params.start.isAfter(params.end)) {
      throw ArgumentError('Start date must be before end date');
    }

    return await _repository.getStatisticsByPeriod(params.start, params.end);
  }
}

@injectable
class GetGenreDistributionUseCase implements UseCase<Map<String, int>, void> {
  final StatisticsRepository _repository;

  GetGenreDistributionUseCase(this._repository);

  @override
  Future<Map<String, int>> call(void params) async {
    return await _repository.getGenreDistribution();
  }
}

@injectable
class GetMonthlyReadingUseCase implements UseCase<Map<String, int>, void> {
  final StatisticsRepository _repository;

  GetMonthlyReadingUseCase(this._repository);

  @override
  Future<Map<String, int>> call(void params) async {
    return await _repository.getMonthlyReading();
  }
}

@injectable
class GetRatingDistributionUseCase implements UseCase<Map<String, double>, void> {
  final StatisticsRepository _repository;

  GetRatingDistributionUseCase(this._repository);

  @override
  Future<Map<String, double>> call(void params) async {
    return await _repository.getRatingDistribution();
  }
}

@injectable
class GetYearlyGoalProgressUseCase implements UseCase<double, int> {
  final StatisticsRepository _repository;

  GetYearlyGoalProgressUseCase(this._repository);

  @override
  Future<double> call(int goal) async {
    if (goal <= 0) {
      throw ArgumentError('Goal must be greater than 0');
    }
    return await _repository.getYearlyGoalProgress(goal);
  }
}

@injectable
class GetReadingSpeedStatsUseCase implements UseCase<Map<String, dynamic>, void> {
  final StatisticsRepository _repository;

  GetReadingSpeedStatsUseCase(this._repository);

  @override
  Future<Map<String, dynamic>> call(void params) async {
    return await _repository.getReadingSpeedStats();
  }
}

@injectable
class ClearStatisticsCacheUseCase implements UseCase<void, void> {
  final StatisticsRepository _repository;

  ClearStatisticsCacheUseCase(this._repository);

  @override
  Future<void> call(void params) async {
    await _repository.clearStatisticsCache();
  }
}

// Use cases compostos para relatórios complexos

@injectable
class GetDashboardDataUseCase implements UseCase<Map<String, dynamic>, void> {
  final GetStatisticsUseCase _getStatsUseCase;
  final GetGenreDistributionUseCase _getGenresUseCase;
  final GetMonthlyReadingUseCase _getMonthlyUseCase;

  GetDashboardDataUseCase(
    this._getStatsUseCase,
    this._getGenresUseCase,
    this._getMonthlyUseCase,
  );

  @override
  Future<Map<String, dynamic>> call(void params) async {
    // Executar todas as operações em paralelo
    final results = await Future.wait([
      _getStatsUseCase(null),
      _getGenresUseCase(null),
      _getMonthlyUseCase(null),
    ]);

    final statistics = results[0] as StatisticsEntity;
    final genreDistribution = results[1] as Map<String, int>;
    final monthlyReading = results[2] as Map<String, int>;

    return {
      'statistics': statistics,
      'genreDistribution': genreDistribution,
      'monthlyReading': monthlyReading,
      'insights': statistics.insights,
      'readerRank': statistics.readerRank,
      'isActiveReader': statistics.isActiveReader,
    };
  }
}

@injectable
class GetYearlyReportUseCase implements UseCase<Map<String, dynamic>, int> {
  final GetStatisticsByPeriodUseCase _getStatsByPeriodUseCase;
  final GetMonthlyReadingUseCase _getMonthlyUseCase;
  final GetGenreDistributionUseCase _getGenresUseCase;

  GetYearlyReportUseCase(
    this._getStatsByPeriodUseCase,
    this._getMonthlyUseCase,
    this._getGenresUseCase,
  );

  @override
  Future<Map<String, dynamic>> call(int year) async {
    // Validar ano
    final currentYear = DateTime.now().year;
    if (year > currentYear) {
      throw ArgumentError('Year cannot be in the future');
    }

    final startOfYear = DateTime(year, 1, 1);
    final endOfYear = DateTime(year, 12, 31, 23, 59, 59);

    // Obter estatísticas do ano
    final yearlyStats = await _getStatsByPeriodUseCase(
      GetStatisticsByPeriodParams(start: startOfYear, end: endOfYear),
    );

    // Obter dados complementares
    final genreDistribution = await _getGenresUseCase(null);
    final monthlyReading = await _getMonthlyUseCase(null);

    // Filtrar dados mensais apenas do ano solicitado
    final yearlyMonthlyReading = <String, int>{};
    monthlyReading.forEach((month, count) {
      if (month.contains(year.toString())) {
        yearlyMonthlyReading[month] = count;
      }
    });

    // Calcular estatísticas adicionais
    final monthsWithReading = yearlyMonthlyReading.values.where((count) => count > 0).length;
    final averageBooksPerMonth = monthsWithReading > 0 
        ? yearlyStats.booksRead / monthsWithReading 
        : 0.0;

    return {
      'year': year,
      'statistics': yearlyStats,
      'genreDistribution': genreDistribution,
      'monthlyReading': yearlyMonthlyReading,
      'summary': {
        'booksRead': yearlyStats.booksRead,
        'pagesRead': yearlyStats.pagesRead,
        'averageRating': yearlyStats.averageRating,
        'favoriteGenre': yearlyStats.favoriteGenre,
        'monthsWithReading': monthsWithReading,
        'averageBooksPerMonth': averageBooksPerMonth,
        'readingConsistency': yearlyStats.readingConsistency,
      },
    };
  }
}

@injectable
class GetReadingTrendsUseCase implements UseCase<Map<String, dynamic>, void> {
  final GetMonthlyReadingUseCase _getMonthlyUseCase;
  final GetGenreDistributionUseCase _getGenresUseCase;
  final GetRatingDistributionUseCase _getRatingsUseCase;

  GetReadingTrendsUseCase(
    this._getMonthlyUseCase,
    this._getGenresUseCase,
    this._getRatingsUseCase,
  );

  @override
  Future<Map<String, dynamic>> call(void params) async {
    // Obter todos os dados
    final results = await Future.wait([
      _getMonthlyUseCase(null),
      _getGenresUseCase(null),
      _getRatingsUseCase(null),
    ]);

    final monthlyReading = results[0] as Map<String, int>;
    final genreDistribution = results[1] as Map<String, int>;
    final ratingDistribution = results[2] as Map<String, double>;

    // Analisar tendências mensais
    final monthlyTrends = _analyzeMonthlyTrends(monthlyReading);
    
    // Analisar tendências de gêneros
    final genreTrends = _analyzeGenreTrends(genreDistribution);
    
    // Analisar tendências de avaliações
    final ratingTrends = _analyzeRatingTrends(ratingDistribution);

    return {
      'monthlyTrends': monthlyTrends,
      'genreTrends': genreTrends,
      'ratingTrends': ratingTrends,
      'summary': {
        'isImproving': monthlyTrends['trend'] == 'crescente',
        'mostPopularGenre': genreTrends['mostPopular'],
        'averageRating': ratingTrends['average'],
        'ratingTrend': ratingTrends['trend'],
      },
    };
  }

  Map<String, dynamic> _analyzeMonthlyTrends(Map<String, int> monthlyReading) {
    if (monthlyReading.isEmpty) {
      return {'trend': 'estável', 'change': 0.0};
    }

    final values = monthlyReading.values.toList();
    if (values.length < 2) {
      return {'trend': 'estável', 'change': 0.0};
    }

    final recent = values.sublist(values.length - 3); // Últimos 3 meses
    final older = values.sublist(0, values.length - 3);

    if (recent.isEmpty || older.isEmpty) {
      return {'trend': 'estável', 'change': 0.0};
    }

    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final olderAvg = older.reduce((a, b) => a + b) / older.length;
    
    final change = olderAvg > 0 ? ((recentAvg - olderAvg) / olderAvg) * 100 : 0.0;
    
    String trend;
    if (change > 10) {
      trend = 'crescente';
    } else if (change < -10) {
      trend = 'decrescente';
    } else {
      trend = 'estável';
    }

    return {
      'trend': trend,
      'change': change,
      'recentAverage': recentAvg,
      'olderAverage': olderAvg,
    };
  }

  Map<String, dynamic> _analyzeGenreTrends(Map<String, int> genreDistribution) {
    if (genreDistribution.isEmpty) {
      return {'mostPopular': null, 'diversity': 0};
    }

    // Encontrar gênero mais popular
    String? mostPopular;
    int maxCount = 0;
    
    genreDistribution.forEach((genre, count) {
      if (count > maxCount) {
        maxCount = count;
        mostPopular = genre;
      }
    });

    // Calcular diversidade (número de gêneros diferentes)
    final diversity = genreDistribution.keys.length;
    
    // Calcular distribuição equilibrada
    final total = genreDistribution.values.reduce((a, b) => a + b);
    final isBalanced = genreDistribution.values.every(
      (count) => (count / total) < 0.5, // Nenhum gênero representa mais de 50%
    );

    return {
      'mostPopular': mostPopular,
      'diversity': diversity,
      'isBalanced': isBalanced,
      'distribution': genreDistribution,
    };
  }

  Map<String, dynamic> _analyzeRatingTrends(Map<String, double> ratingDistribution) {
    if (ratingDistribution.isEmpty) {
      return {'average': 0.0, 'trend': 'neutro'};
    }

    // Calcular média ponderada
    double totalRating = 0.0;
    double totalCount = 0.0;
    
    ratingDistribution.forEach((rating, count) {
      final ratingValue = double.tryParse(rating) ?? 0.0;
      totalRating += ratingValue * count;
      totalCount += count;
    });

    final average = totalCount > 0 ? totalRating / totalCount : 0.0;
    
    // Determinar tendência baseada na média
    String trend;
    if (average >= 4.0) {
      trend = 'positivo';
    } else if (average >= 3.0) {
      trend = 'neutro';
    } else {
      trend = 'negativo';
    }

    // Calcular distribuição de ratings altos vs baixos
    double highRatings = 0.0;
    double lowRatings = 0.0;
    
    ratingDistribution.forEach((rating, count) {
      final ratingValue = double.tryParse(rating) ?? 0.0;
      if (ratingValue >= 4.0) {
        highRatings += count;
      } else if (ratingValue <= 2.0) {
        lowRatings += count;
      }
    });

    return {
      'average': average,
      'trend': trend,
      'highRatings': highRatings,
      'lowRatings': lowRatings,
      'distribution': ratingDistribution,
    };
  }
}
