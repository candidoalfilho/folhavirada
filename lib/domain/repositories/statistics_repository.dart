// 📚 FolhaVirada - Statistics Repository Interface
// Interface do repositório de estatísticas

import 'package:folhavirada/domain/entities/statistics_entity.dart';

abstract class StatisticsRepository {
  /// Calcular e obter estatísticas atualizadas
  Future<StatisticsEntity> calculateStatistics();

  /// Obter estatísticas em cache (se disponível)
  Future<StatisticsEntity?> getCachedStatistics();

  /// Salvar estatísticas em cache
  Future<void> cacheStatistics(StatisticsEntity statistics);

  /// Limpar cache de estatísticas
  Future<void> clearStatisticsCache();

  /// Obter estatísticas por período
  Future<StatisticsEntity> getStatisticsByPeriod(DateTime start, DateTime end);

  /// Obter distribuição de gêneros
  Future<Map<String, int>> getGenreDistribution();

  /// Obter leitura mensal
  Future<Map<String, int>> getMonthlyReading();

  /// Obter distribuição de avaliações
  Future<Map<String, double>> getRatingDistribution();

  /// Obter progresso da meta anual
  Future<double> getYearlyGoalProgress(int goal);

  /// Obter estatísticas de velocidade de leitura
  Future<Map<String, dynamic>> getReadingSpeedStats();

  /// Verificar se precisa recalcular estatísticas
  Future<bool> needsRecalculation();
}
