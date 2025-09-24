// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:folhavirada/core/di/injection_modules.dart' as _i25;
import 'package:folhavirada/core/services/database_service.dart' as _i1025;
import 'package:folhavirada/core/services/storage_service.dart' as _i761;
import 'package:folhavirada/data/datasources/book_local_datasource.dart'
    as _i1027;
import 'package:folhavirada/data/datasources/book_remote_datasource.dart'
    as _i604;
import 'package:folhavirada/data/datasources/note_local_datasource.dart'
    as _i318;
import 'package:folhavirada/data/datasources/statistics_local_datasource.dart'
    as _i155;
import 'package:folhavirada/data/repositories/book_repository_impl.dart'
    as _i213;
import 'package:folhavirada/data/repositories/note_repository_impl.dart'
    as _i665;
import 'package:folhavirada/data/repositories/statistics_repository_impl.dart'
    as _i924;
import 'package:folhavirada/domain/repositories/book_repository.dart' as _i503;
import 'package:folhavirada/domain/repositories/note_repository.dart' as _i846;
import 'package:folhavirada/domain/repositories/statistics_repository.dart'
    as _i653;
import 'package:folhavirada/domain/usecases/book_usecases.dart' as _i129;
import 'package:folhavirada/domain/usecases/note_usecases.dart' as _i698;
import 'package:folhavirada/domain/usecases/statistics_usecases.dart' as _i818;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectableModule = _$InjectableModule();
    gh.lazySingleton<_i1025.DatabaseService>(() => _i1025.DatabaseService());
    gh.lazySingleton<_i761.StorageService>(() => _i761.StorageService());
    gh.lazySingleton<_i361.Dio>(() => injectableModule.provideDio());
    gh.lazySingleton<_i1027.BookLocalDatasource>(
      () => _i1027.BookLocalDatasourceImpl(gh<_i1025.DatabaseService>()),
    );
    gh.lazySingleton<_i155.StatisticsLocalDatasource>(
      () => _i155.StatisticsLocalDatasourceImpl(gh<_i1025.DatabaseService>()),
    );
    gh.lazySingleton<_i604.BookRemoteDatasource>(
      () => _i604.BookRemoteDatasourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i318.NoteLocalDatasource>(
      () => _i318.NoteLocalDatasourceImpl(gh<_i1025.DatabaseService>()),
    );
    gh.lazySingleton<_i846.NoteRepository>(
      () => _i665.NoteRepositoryImpl(gh<_i318.NoteLocalDatasource>()),
    );
    gh.lazySingleton<_i503.BookRepository>(
      () => _i213.BookRepositoryImpl(
        gh<_i1027.BookLocalDatasource>(),
        gh<_i604.BookRemoteDatasource>(),
      ),
    );
    gh.factory<_i698.GetNotesByBookIdUseCase>(
      () => _i698.GetNotesByBookIdUseCase(gh<_i846.NoteRepository>()),
    );
    gh.factory<_i698.GetNoteByIdUseCase>(
      () => _i698.GetNoteByIdUseCase(gh<_i846.NoteRepository>()),
    );
    gh.factory<_i698.SearchNotesUseCase>(
      () => _i698.SearchNotesUseCase(gh<_i846.NoteRepository>()),
    );
    gh.factory<_i698.AddNoteUseCase>(
      () => _i698.AddNoteUseCase(gh<_i846.NoteRepository>()),
    );
    gh.factory<_i698.UpdateNoteUseCase>(
      () => _i698.UpdateNoteUseCase(gh<_i846.NoteRepository>()),
    );
    gh.factory<_i698.DeleteNoteUseCase>(
      () => _i698.DeleteNoteUseCase(gh<_i846.NoteRepository>()),
    );
    gh.factory<_i698.GetAllNotesUseCase>(
      () => _i698.GetAllNotesUseCase(gh<_i846.NoteRepository>()),
    );
    gh.factory<_i698.GetRecentNotesUseCase>(
      () => _i698.GetRecentNotesUseCase(gh<_i846.NoteRepository>()),
    );
    gh.factory<_i698.GetNotesCountByBookIdUseCase>(
      () => _i698.GetNotesCountByBookIdUseCase(gh<_i846.NoteRepository>()),
    );
    gh.factory<_i698.DeleteNotesByBookIdUseCase>(
      () => _i698.DeleteNotesByBookIdUseCase(gh<_i846.NoteRepository>()),
    );
    gh.factory<_i698.ExportNotesUseCase>(
      () => _i698.ExportNotesUseCase(gh<_i846.NoteRepository>()),
    );
    gh.factory<_i698.ImportNotesUseCase>(
      () => _i698.ImportNotesUseCase(gh<_i846.NoteRepository>()),
    );
    gh.factory<_i698.ClearAllNotesUseCase>(
      () => _i698.ClearAllNotesUseCase(gh<_i846.NoteRepository>()),
    );
    gh.lazySingleton<_i653.StatisticsRepository>(
      () => _i924.StatisticsRepositoryImpl(
        gh<_i155.StatisticsLocalDatasource>(),
        gh<_i1027.BookLocalDatasource>(),
      ),
    );
    gh.factory<_i698.DuplicateNoteUseCase>(
      () => _i698.DuplicateNoteUseCase(
        gh<_i698.GetNoteByIdUseCase>(),
        gh<_i698.AddNoteUseCase>(),
      ),
    );
    gh.factory<_i818.GetStatisticsUseCase>(
      () => _i818.GetStatisticsUseCase(gh<_i653.StatisticsRepository>()),
    );
    gh.factory<_i818.ForceRecalculateStatisticsUseCase>(
      () => _i818.ForceRecalculateStatisticsUseCase(
        gh<_i653.StatisticsRepository>(),
      ),
    );
    gh.factory<_i818.GetStatisticsByPeriodUseCase>(
      () =>
          _i818.GetStatisticsByPeriodUseCase(gh<_i653.StatisticsRepository>()),
    );
    gh.factory<_i818.GetGenreDistributionUseCase>(
      () => _i818.GetGenreDistributionUseCase(gh<_i653.StatisticsRepository>()),
    );
    gh.factory<_i818.GetMonthlyReadingUseCase>(
      () => _i818.GetMonthlyReadingUseCase(gh<_i653.StatisticsRepository>()),
    );
    gh.factory<_i818.GetRatingDistributionUseCase>(
      () =>
          _i818.GetRatingDistributionUseCase(gh<_i653.StatisticsRepository>()),
    );
    gh.factory<_i818.GetYearlyGoalProgressUseCase>(
      () =>
          _i818.GetYearlyGoalProgressUseCase(gh<_i653.StatisticsRepository>()),
    );
    gh.factory<_i818.GetReadingSpeedStatsUseCase>(
      () => _i818.GetReadingSpeedStatsUseCase(gh<_i653.StatisticsRepository>()),
    );
    gh.factory<_i818.ClearStatisticsCacheUseCase>(
      () => _i818.ClearStatisticsCacheUseCase(gh<_i653.StatisticsRepository>()),
    );
    gh.factory<_i129.GetAllBooksUseCase>(
      () => _i129.GetAllBooksUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.GetBookByIdUseCase>(
      () => _i129.GetBookByIdUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.SearchBooksUseCase>(
      () => _i129.SearchBooksUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.SearchBooksOnlineUseCase>(
      () => _i129.SearchBooksOnlineUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.AddBookUseCase>(
      () => _i129.AddBookUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.UpdateBookUseCase>(
      () => _i129.UpdateBookUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.DeleteBookUseCase>(
      () => _i129.DeleteBookUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.UpdateBookProgressUseCase>(
      () => _i129.UpdateBookProgressUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.UpdateBookStatusUseCase>(
      () => _i129.UpdateBookStatusUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.UpdateBookRatingUseCase>(
      () => _i129.UpdateBookRatingUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.GetBooksByStatusUseCase>(
      () => _i129.GetBooksByStatusUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.GetCurrentlyReadingUseCase>(
      () => _i129.GetCurrentlyReadingUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.GetRecentBooksUseCase>(
      () => _i129.GetRecentBooksUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.GetFavoriteBooksUseCase>(
      () => _i129.GetFavoriteBooksUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.GetBooksCountUseCase>(
      () => _i129.GetBooksCountUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.ExportBooksUseCase>(
      () => _i129.ExportBooksUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.ImportBooksUseCase>(
      () => _i129.ImportBooksUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.ClearAllBooksUseCase>(
      () => _i129.ClearAllBooksUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.GetAllGenresUseCase>(
      () => _i129.GetAllGenresUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.GetAllAuthorsUseCase>(
      () => _i129.GetAllAuthorsUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i129.GetRecommendationsUseCase>(
      () => _i129.GetRecommendationsUseCase(gh<_i503.BookRepository>()),
    );
    gh.factory<_i818.GetYearlyReportUseCase>(
      () => _i818.GetYearlyReportUseCase(
        gh<_i818.GetStatisticsByPeriodUseCase>(),
        gh<_i818.GetMonthlyReadingUseCase>(),
        gh<_i818.GetGenreDistributionUseCase>(),
      ),
    );
    gh.factory<_i818.GetDashboardDataUseCase>(
      () => _i818.GetDashboardDataUseCase(
        gh<_i818.GetStatisticsUseCase>(),
        gh<_i818.GetGenreDistributionUseCase>(),
        gh<_i818.GetMonthlyReadingUseCase>(),
      ),
    );
    gh.factory<_i129.StartReadingBookUseCase>(
      () => _i129.StartReadingBookUseCase(
        gh<_i129.UpdateBookStatusUseCase>(),
        gh<_i129.GetBookByIdUseCase>(),
      ),
    );
    gh.factory<_i698.GetNotesWithBookInfoUseCase>(
      () => _i698.GetNotesWithBookInfoUseCase(
        gh<_i698.GetNotesByBookIdUseCase>(),
        gh<_i698.GetNotesCountByBookIdUseCase>(),
      ),
    );
    gh.factory<_i818.GetReadingTrendsUseCase>(
      () => _i818.GetReadingTrendsUseCase(
        gh<_i818.GetMonthlyReadingUseCase>(),
        gh<_i818.GetGenreDistributionUseCase>(),
        gh<_i818.GetRatingDistributionUseCase>(),
      ),
    );
    gh.factory<_i129.FinishReadingBookUseCase>(
      () => _i129.FinishReadingBookUseCase(
        gh<_i129.UpdateBookStatusUseCase>(),
        gh<_i129.UpdateBookProgressUseCase>(),
        gh<_i129.GetBookByIdUseCase>(),
      ),
    );
    return this;
  }
}

class _$InjectableModule extends _i25.InjectableModule {}
