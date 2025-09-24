// 📚 FolhaVirada - Statistics Local Datasource
// Datasource para operações locais com estatísticas

import 'package:injectable/injectable.dart';
import 'package:folhavirada/core/services/database_service.dart';
import 'package:folhavirada/core/constants/app_constants.dart';
import 'package:folhavirada/data/models/statistics_model.dart';

abstract class StatisticsLocalDatasource {
  Future<StatisticsModel?> getCachedStatistics();
  Future<void> cacheStatistics(StatisticsModel statistics);
  Future<void> clearStatisticsCache();
}

@LazySingleton(as: StatisticsLocalDatasource)
class StatisticsLocalDatasourceImpl implements StatisticsLocalDatasource {
  final DatabaseService _databaseService;
  static const String _cacheKey = 'main_statistics';

  StatisticsLocalDatasourceImpl(this._databaseService);

  @override
  Future<StatisticsModel?> getCachedStatistics() async {
    try {
      final results = await _databaseService.query(
        AppConstants.statisticsTable,
        where: 'id = ?',
        whereArgs: [_cacheKey],
        limit: 1,
      );

      if (results.isEmpty) return null;
      
      final data = results.first;
      return StatisticsModel(
        totalBooks: data['total_books'] as int? ?? 0,
        booksRead: data['books_read'] as int? ?? 0,
        booksReading: data['books_reading'] as int? ?? 0,
        booksWantToRead: data['books_want_to_read'] as int? ?? 0,
        totalPages: data['total_pages'] as int? ?? 0,
        pagesRead: data['pages_read'] as int? ?? 0,
        averageRating: (data['average_rating'] as num?)?.toDouble() ?? 0.0,
        booksThisYear: data['books_this_year'] as int? ?? 0,
        booksThisMonth: data['books_this_month'] as int? ?? 0,
        favoriteGenre: data['favorite_genre'] as String?,
        averageReadingDays: (data['average_reading_days'] as num?)?.toDouble() ?? 0.0,
        genreDistribution: _parseStringMap(data['genre_distribution'] as String?),
        monthlyReading: _parseStringMap(data['monthly_reading'] as String?),
        ratingDistribution: _parseDoubleMap(data['rating_distribution'] as String?),
        calculatedAt: data['calculated_at'] as String,
      );
    } catch (e) {
      throw Exception('Failed to get cached statistics from database: $e');
    }
  }

  @override
  Future<void> cacheStatistics(StatisticsModel statistics) async {
    try {
      final data = {
        'id': _cacheKey,
        'stat_type': 'main_statistics',
        'total_books': statistics.totalBooks,
        'books_read': statistics.booksRead,
        'books_reading': statistics.booksReading,
        'books_want_to_read': statistics.booksWantToRead,
        'total_pages': statistics.totalPages,
        'pages_read': statistics.pagesRead,
        'average_rating': statistics.averageRating,
        'books_this_year': statistics.booksThisYear,
        'books_this_month': statistics.booksThisMonth,
        'favorite_genre': statistics.favoriteGenre,
        'average_reading_days': statistics.averageReadingDays,
        'genre_distribution': _mapToString(statistics.genreDistribution),
        'monthly_reading': _mapToString(statistics.monthlyReading),
        'rating_distribution': _mapToString(statistics.ratingDistribution),
        'calculated_at': statistics.calculatedAt,
      };

      // Verificar se já existe
      final exists = await _databaseService.exists(
        AppConstants.statisticsTable,
        'id = ?',
        [_cacheKey],
      );

      if (exists) {
        await _databaseService.update(
          AppConstants.statisticsTable,
          data,
          'id = ?',
          [_cacheKey],
        );
      } else {
        await _databaseService.insert(AppConstants.statisticsTable, data);
      }
    } catch (e) {
      throw Exception('Failed to cache statistics in database: $e');
    }
  }

  @override
  Future<void> clearStatisticsCache() async {
    try {
      await _databaseService.delete(
        AppConstants.statisticsTable,
        'id = ?',
        [_cacheKey],
      );
    } catch (e) {
      throw Exception('Failed to clear statistics cache from database: $e');
    }
  }

  // Métodos auxiliares para serialização
  Map<String, int> _parseStringMap(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      final map = <String, int>{};
      final parts = jsonString.split(',');
      for (final part in parts) {
        if (part.trim().isEmpty) continue;
        final keyValue = part.split(':');
        if (keyValue.length == 2) {
          map[keyValue[0].trim()] = int.tryParse(keyValue[1].trim()) ?? 0;
        }
      }
      return map;
    } catch (e) {
      return {};
    }
  }

  Map<String, double> _parseDoubleMap(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      final map = <String, double>{};
      final parts = jsonString.split(',');
      for (final part in parts) {
        if (part.trim().isEmpty) continue;
        final keyValue = part.split(':');
        if (keyValue.length == 2) {
          map[keyValue[0].trim()] = double.tryParse(keyValue[1].trim()) ?? 0.0;
        }
      }
      return map;
    } catch (e) {
      return {};
    }
  }

  String _mapToString(Map<String, dynamic> map) {
    if (map.isEmpty) return '';
    return map.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}:${e.value}')
        .join(',');
  }
}
