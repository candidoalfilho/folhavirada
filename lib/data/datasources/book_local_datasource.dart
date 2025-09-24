// 📚 FolhaVirada - Book Local Datasource
// Datasource para operações locais com livros

import 'package:injectable/injectable.dart';
import 'package:folhavirada/core/services/database_service.dart';
import 'package:folhavirada/core/constants/app_constants.dart';
import 'package:folhavirada/data/models/book_model.dart';

abstract class BookLocalDatasource {
  Future<List<BookModel>> getAllBooks({
    String? status,
    String? genre,
    String? sortBy,
    bool ascending = true,
    int? limit,
    int? offset,
  });

  Future<BookModel?> getBookById(String id);
  Future<List<BookModel>> searchBooks(String query);
  Future<BookModel> insertBook(BookModel book);
  Future<BookModel> updateBook(BookModel book);
  Future<void> deleteBook(String id);
  Future<int> getBooksCount({String? status, String? genre});
  Future<void> clearAllBooks();
  Future<List<String>> getAllGenres();
  Future<List<String>> getAllAuthors();
  Future<List<BookModel>> getBooksByAuthor(String author);
  Future<List<BookModel>> getBooksByYear(int year);
  Future<bool> isDuplicateBook(String title, String author);
}

@LazySingleton(as: BookLocalDatasource)
class BookLocalDatasourceImpl implements BookLocalDatasource {
  final DatabaseService _databaseService;

  BookLocalDatasourceImpl(this._databaseService);

  @override
  Future<List<BookModel>> getAllBooks({
    String? status,
    String? genre,
    String? sortBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    try {
      final whereConditions = <String>[];
      final whereArgs = <dynamic>[];

      if (status != null) {
        whereConditions.add('status = ?');
        whereArgs.add(status);
      }

      if (genre != null) {
        whereConditions.add('genre = ?');
        whereArgs.add(genre);
      }

      final whereClause = whereConditions.isNotEmpty 
          ? whereConditions.join(' AND ') 
          : null;

      String? orderBy;
      if (sortBy != null) {
        final direction = ascending ? 'ASC' : 'DESC';
        switch (sortBy) {
          case 'title':
            orderBy = 'title $direction';
            break;
          case 'author':
            orderBy = 'author $direction';
            break;
          case 'created_at':
            orderBy = 'created_at $direction';
            break;
          case 'updated_at':
            orderBy = 'updated_at $direction';
            break;
          case 'rating':
            orderBy = 'rating $direction';
            break;
          case 'published_year':
            orderBy = 'published_year $direction';
            break;
          default:
            orderBy = 'created_at DESC';
        }
      }

      final results = await _databaseService.query(
        AppConstants.booksTable,
        where: whereClause,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      return results.map((map) => BookModel.fromDatabase(map)).toList();
    } catch (e) {
      throw Exception('Failed to get all books from database: $e');
    }
  }

  @override
  Future<BookModel?> getBookById(String id) async {
    try {
      final results = await _databaseService.query(
        AppConstants.booksTable,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) return null;
      return BookModel.fromDatabase(results.first);
    } catch (e) {
      throw Exception('Failed to get book by id from database: $e');
    }
  }

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    try {
      final searchQuery = '%$query%';
      final results = await _databaseService.query(
        AppConstants.booksTable,
        where: 'title LIKE ? OR author LIKE ? OR description LIKE ?',
        whereArgs: [searchQuery, searchQuery, searchQuery],
        orderBy: 'title ASC',
      );

      return results.map((map) => BookModel.fromDatabase(map)).toList();
    } catch (e) {
      throw Exception('Failed to search books in database: $e');
    }
  }

  @override
  Future<BookModel> insertBook(BookModel book) async {
    try {
      final bookWithTimestamps = book.copyWith(
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _databaseService.insert(
        AppConstants.booksTable,
        bookWithTimestamps.toDatabase(),
      );

      return bookWithTimestamps;
    } catch (e) {
      throw Exception('Failed to insert book into database: $e');
    }
  }

  @override
  Future<BookModel> updateBook(BookModel book) async {
    try {
      final bookWithTimestamp = book.copyWith(
        updatedAt: DateTime.now().toIso8601String(),
      );

      final rowsAffected = await _databaseService.update(
        AppConstants.booksTable,
        bookWithTimestamp.toDatabase(),
        'id = ?',
        [book.id],
      );

      if (rowsAffected == 0) {
        throw Exception('Book not found for update');
      }

      return bookWithTimestamp;
    } catch (e) {
      throw Exception('Failed to update book in database: $e');
    }
  }

  @override
  Future<void> deleteBook(String id) async {
    try {
      // Primeiro deletar notas associadas
      await _databaseService.delete(
        AppConstants.notesTable,
        'book_id = ?',
        [id],
      );

      // Depois deletar o livro
      final rowsAffected = await _databaseService.delete(
        AppConstants.booksTable,
        'id = ?',
        [id],
      );

      if (rowsAffected == 0) {
        throw Exception('Book not found for deletion');
      }
    } catch (e) {
      throw Exception('Failed to delete book from database: $e');
    }
  }

  @override
  Future<int> getBooksCount({String? status, String? genre}) async {
    try {
      final whereConditions = <String>[];
      final whereArgs = <dynamic>[];

      if (status != null) {
        whereConditions.add('status = ?');
        whereArgs.add(status);
      }

      if (genre != null) {
        whereConditions.add('genre = ?');
        whereArgs.add(genre);
      }

      final whereClause = whereConditions.isNotEmpty 
          ? whereConditions.join(' AND ') 
          : null;

      return await _databaseService.count(
        AppConstants.booksTable,
        where: whereClause,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      );
    } catch (e) {
      throw Exception('Failed to get books count from database: $e');
    }
  }

  @override
  Future<void> clearAllBooks() async {
    try {
      // Primeiro limpar notas
      await _databaseService.clearTable(AppConstants.notesTable);
      // Depois limpar livros
      await _databaseService.clearTable(AppConstants.booksTable);
    } catch (e) {
      throw Exception('Failed to clear all books from database: $e');
    }
  }

  @override
  Future<List<String>> getAllGenres() async {
    try {
      final results = await _databaseService.rawQuery(
        'SELECT DISTINCT genre FROM ${AppConstants.booksTable} WHERE genre IS NOT NULL ORDER BY genre ASC',
      );

      return results
          .map((row) => row['genre'] as String)
          .where((genre) => genre.isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception('Failed to get all genres from database: $e');
    }
  }

  @override
  Future<List<String>> getAllAuthors() async {
    try {
      final results = await _databaseService.rawQuery(
        'SELECT DISTINCT author FROM ${AppConstants.booksTable} ORDER BY author ASC',
      );

      return results
          .map((row) => row['author'] as String)
          .where((author) => author.isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception('Failed to get all authors from database: $e');
    }
  }

  @override
  Future<List<BookModel>> getBooksByAuthor(String author) async {
    try {
      final results = await _databaseService.query(
        AppConstants.booksTable,
        where: 'author = ?',
        whereArgs: [author],
        orderBy: 'title ASC',
      );

      return results.map((map) => BookModel.fromDatabase(map)).toList();
    } catch (e) {
      throw Exception('Failed to get books by author from database: $e');
    }
  }

  @override
  Future<List<BookModel>> getBooksByYear(int year) async {
    try {
      final results = await _databaseService.query(
        AppConstants.booksTable,
        where: 'published_year = ?',
        whereArgs: [year],
        orderBy: 'title ASC',
      );

      return results.map((map) => BookModel.fromDatabase(map)).toList();
    } catch (e) {
      throw Exception('Failed to get books by year from database: $e');
    }
  }

  @override
  Future<bool> isDuplicateBook(String title, String author) async {
    try {
      final count = await _databaseService.count(
        AppConstants.booksTable,
        where: 'LOWER(title) = LOWER(?) AND LOWER(author) = LOWER(?)',
        whereArgs: [title.trim(), author.trim()],
      );

      return count > 0;
    } catch (e) {
      throw Exception('Failed to check duplicate book in database: $e');
    }
  }
}
