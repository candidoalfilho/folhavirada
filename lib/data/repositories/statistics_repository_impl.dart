// 📚 FolhaVirada - Statistics Repository Implementation
// Implementação do repositório de estatísticas

import 'package:injectable/injectable.dart';
import 'package:folhavirada/data/datasources/statistics_local_datasource.dart';
import 'package:folhavirada/data/datasources/book_local_datasource.dart';
import 'package:folhavirada/data/models/statistics_model.dart';
import 'package:folhavirada/domain/entities/statistics_entity.dart';
import 'package:folhavirada/domain/repositories/statistics_repository.dart';
import 'package:folhavirada/core/constants/app_constants.dart';

@LazySingleton(as: StatisticsRepository)
class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsLocalDatasource _statisticsDatasource;
  final BookLocalDatasource _bookDatasource;

  StatisticsRepositoryImpl(
    this._statisticsDatasource,
    this._bookDatasource,
  );

  @override
  Future<StatisticsEntity> calculateStatistics() async {
    try {
      // Obter todos os livros
      final allBooks = await _bookDatasource.getAllBooks();
      
      if (allBooks.isEmpty) {
        return StatisticsEntity.empty();
      }

      final now = DateTime.now();
      final currentYear = now.year;
      final currentMonth = now.month;

      // Contadores básicos
      int totalBooks = allBooks.length;
      int booksRead = 0;
      int booksReading = 0;
      int booksWantToRead = 0;
      int totalPages = 0;
      int pagesRead = 0;
      int booksThisYear = 0;
      int booksThisMonth = 0;

      double totalRating = 0.0;
      int ratedBooks = 0;
      int totalReadingDays = 0;
      int booksWithReadingTime = 0;

      // Distribuições
      final genreDistribution = <String, int>{};
      final monthlyReading = <String, int>{};
      final ratingDistribution = <String, double>{};

      // Processar cada livro
      for (final book in allBooks) {
        // Contadores por status
        switch (book.status) {
          case 'read':
            booksRead++;
            break;
          case 'reading':
            booksReading++;
            break;
          case 'want_to_read':
            booksWantToRead++;
            break;
        }

        // Páginas
        totalPages += book.totalPages;
        if (book.status == 'read') {
          pagesRead += book.totalPages;
        } else if (book.status == 'reading') {
          pagesRead += book.currentPage;
        }

        // Livros deste ano e mês
        final createdAt = DateTime.tryParse(book.createdAt);
        if (createdAt != null) {
          if (createdAt.year == currentYear) {
            booksThisYear++;
            if (createdAt.month == currentMonth) {
              booksThisMonth++;
            }
          }

          // Distribuição mensal
          final monthKey = '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}';
          monthlyReading[monthKey] = (monthlyReading[monthKey] ?? 0) + 1;
        }

        // Distribuição por gênero
        if (book.genre != null && book.genre!.isNotEmpty) {
          genreDistribution[book.genre!] = (genreDistribution[book.genre!] ?? 0) + 1;
        }

        // Avaliações
        if (book.rating > 0) {
          totalRating += book.rating;
          ratedBooks++;
          
          final ratingKey = book.rating.toString();
          ratingDistribution[ratingKey] = (ratingDistribution[ratingKey] ?? 0) + 1;
        }

        // Tempo de leitura
        if (book.startDate != null && book.endDate != null) {
          final startDate = DateTime.tryParse(book.startDate!);
          final endDate = DateTime.tryParse(book.endDate!);
          
          if (startDate != null && endDate != null) {
            final readingDays = endDate.difference(startDate).inDays + 1;
            totalReadingDays += readingDays;
            booksWithReadingTime++;
          }
        }
      }

      // Calcular médias
      final averageRating = ratedBooks > 0 ? totalRating / ratedBooks : 0.0;
      final averageReadingDays = booksWithReadingTime > 0 
          ? totalReadingDays / booksWithReadingTime.toDouble()
          : 0.0;

      // Encontrar gênero favorito
      String? favoriteGenre;
      if (genreDistribution.isNotEmpty) {
        favoriteGenre = genreDistribution.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
      }

      // Criar modelo de estatísticas
      final statistics = StatisticsModel(
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
        calculatedAt: DateTime.now().toIso8601String(),
      );

      return statistics.toEntity();
    } catch (e) {
      throw Exception('Failed to calculate statistics: $e');
    }
  }

  @override
  Future<StatisticsEntity?> getCachedStatistics() async {
    try {
      final model = await _statisticsDatasource.getCachedStatistics();
      return model?.toEntity();
    } catch (e) {
      throw Exception('Failed to get cached statistics: $e');
    }
  }

  @override
  Future<void> cacheStatistics(StatisticsEntity statistics) async {
    try {
      final model = StatisticsModel.fromEntity(statistics);
      await _statisticsDatasource.cacheStatistics(model);
    } catch (e) {
      throw Exception('Failed to cache statistics: $e');
    }
  }

  @override
  Future<void> clearStatisticsCache() async {
    try {
      await _statisticsDatasource.clearStatisticsCache();
    } catch (e) {
      throw Exception('Failed to clear statistics cache: $e');
    }
  }

  @override
  Future<StatisticsEntity> getStatisticsByPeriod(DateTime start, DateTime end) async {
    try {
      // Obter livros do período
      final allBooks = await _bookDatasource.getAllBooks();
      final periodBooks = allBooks.where((book) {
        final createdAt = DateTime.tryParse(book.createdAt);
        return createdAt != null && 
               createdAt.isAfter(start.subtract(const Duration(days: 1))) &&
               createdAt.isBefore(end.add(const Duration(days: 1)));
      }).toList();

      // Calcular estatísticas apenas para os livros do período
      // (Implementação similar ao calculateStatistics, mas filtrada)
      
      // Para simplicidade, retornamos estatísticas vazias por enquanto
      // TODO: Implementar cálculo específico do período
      return StatisticsEntity.empty();
    } catch (e) {
      throw Exception('Failed to get statistics by period: $e');
    }
  }

  @override
  Future<Map<String, int>> getGenreDistribution() async {
    try {
      final allBooks = await _bookDatasource.getAllBooks();
      final distribution = <String, int>{};

      for (final book in allBooks) {
        if (book.genre != null && book.genre!.isNotEmpty) {
          distribution[book.genre!] = (distribution[book.genre!] ?? 0) + 1;
        }
      }

      return distribution;
    } catch (e) {
      throw Exception('Failed to get genre distribution: $e');
    }
  }

  @override
  Future<Map<String, int>> getMonthlyReading() async {
    try {
      final allBooks = await _bookDatasource.getAllBooks();
      final monthlyReading = <String, int>{};

      for (final book in allBooks) {
        final createdAt = DateTime.tryParse(book.createdAt);
        if (createdAt != null) {
          final monthKey = '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}';
          monthlyReading[monthKey] = (monthlyReading[monthKey] ?? 0) + 1;
        }
      }

      return monthlyReading;
    } catch (e) {
      throw Exception('Failed to get monthly reading: $e');
    }
  }

  @override
  Future<Map<String, double>> getRatingDistribution() async {
    try {
      final allBooks = await _bookDatasource.getAllBooks();
      final distribution = <String, double>{};

      for (final book in allBooks) {
        if (book.rating > 0) {
          final ratingKey = book.rating.toString();
          distribution[ratingKey] = (distribution[ratingKey] ?? 0) + 1;
        }
      }

      return distribution;
    } catch (e) {
      throw Exception('Failed to get rating distribution: $e');
    }
  }

  @override
  Future<double> getYearlyGoalProgress(int goal) async {
    try {
      final currentYear = DateTime.now().year;
      final booksThisYear = await _bookDatasource.getBooksCount(
        status: 'read',
        // TODO: Adicionar filtro por ano quando implementado
      );

      if (goal == 0) return 0.0;
      return (booksThisYear / goal * 100).clamp(0.0, 100.0);
    } catch (e) {
      throw Exception('Failed to get yearly goal progress: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getReadingSpeedStats() async {
    try {
      final allBooks = await _bookDatasource.getAllBooks();
      final readBooks = allBooks.where((book) => book.status == 'read').toList();

      if (readBooks.isEmpty) {
        return {
          'averagePagesPerDay': 0.0,
          'averageDaysPerBook': 0.0,
          'fastestBook': null,
          'slowestBook': null,
        };
      }

      double totalPagesPerDay = 0.0;
      double totalDaysPerBook = 0.0;
      int validBooks = 0;

      for (final book in readBooks) {
        if (book.startDate != null && book.endDate != null) {
          final startDate = DateTime.tryParse(book.startDate!);
          final endDate = DateTime.tryParse(book.endDate!);
          
          if (startDate != null && endDate != null) {
            final days = endDate.difference(startDate).inDays + 1;
            final pagesPerDay = book.totalPages / days;
            
            totalPagesPerDay += pagesPerDay;
            totalDaysPerBook += days;
            validBooks++;
          }
        }
      }

      final averagePagesPerDay = validBooks > 0 ? totalPagesPerDay / validBooks : 0.0;
      final averageDaysPerBook = validBooks > 0 ? totalDaysPerBook / validBooks : 0.0;

      return {
        'averagePagesPerDay': averagePagesPerDay,
        'averageDaysPerBook': averageDaysPerBook,
        'totalBooksWithData': validBooks,
        'totalReadBooks': readBooks.length,
      };
    } catch (e) {
      throw Exception('Failed to get reading speed stats: $e');
    }
  }

  @override
  Future<bool> needsRecalculation() async {
    try {
      final cached = await getCachedStatistics();
      if (cached == null) return true;

      // Verificar se as estatísticas foram calculadas nas últimas 6 horas
      final sixHoursAgo = DateTime.now().subtract(const Duration(hours: 6));
      return cached.calculatedAt.isBefore(sixHoursAgo);
    } catch (e) {
      return true; // Em caso de erro, recalcular
    }
  }
}
