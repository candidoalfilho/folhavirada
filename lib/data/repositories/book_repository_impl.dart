// 📚 FolhaVirada - Book Repository Implementation
// Implementação do repositório de livros

import 'package:injectable/injectable.dart';
import 'package:folhavirada/data/datasources/book_local_datasource.dart';
import 'package:folhavirada/data/datasources/book_remote_datasource.dart';
import 'package:folhavirada/data/models/book_model.dart';
import 'package:folhavirada/domain/entities/book_entity.dart';
import 'package:folhavirada/domain/repositories/book_repository.dart';
import 'package:folhavirada/core/constants/app_constants.dart';

@LazySingleton(as: BookRepository)
class BookRepositoryImpl implements BookRepository {
  final BookLocalDatasource _localDatasource;
  final BookRemoteDatasource _remoteDatasource;

  BookRepositoryImpl(
    this._localDatasource,
    this._remoteDatasource,
  );

  @override
  Future<List<BookEntity>> getAllBooks({
    BookStatus? status,
    String? genre,
    String? sortBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    try {
      final models = await _localDatasource.getAllBooks(
        status: status?.value,
        genre: genre,
        sortBy: sortBy,
        ascending: ascending,
        limit: limit,
        offset: offset,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get books: $e');
    }
  }

  @override
  Future<BookEntity?> getBookById(String id) async {
    try {
      final model = await _localDatasource.getBookById(id);
      return model?.toEntity();
    } catch (e) {
      throw Exception('Failed to get book by id: $e');
    }
  }

  @override
  Future<List<BookEntity>> searchBooks(String query) async {
    try {
      final models = await _localDatasource.searchBooks(query);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search books: $e');
    }
  }

  @override
  Future<List<BookEntity>> searchBooksOnline(String query) async {
    try {
      final models = await _remoteDatasource.searchBooks(query);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search books online: $e');
    }
  }

  @override
  Future<BookEntity> addBook(BookEntity book) async {
    try {
      final model = BookModel.fromEntity(book);
      final savedModel = await _localDatasource.insertBook(model);
      return savedModel.toEntity();
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  @override
  Future<BookEntity> updateBook(BookEntity book) async {
    try {
      final model = BookModel.fromEntity(book);
      final updatedModel = await _localDatasource.updateBook(model);
      return updatedModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  @override
  Future<void> deleteBook(String id) async {
    try {
      await _localDatasource.deleteBook(id);
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  @override
  Future<BookEntity> updateBookStatus(String id, BookStatus status) async {
    try {
      final book = await getBookById(id);
      if (book == null) {
        throw Exception('Book not found');
      }

      // Atualizar datas baseado no status
      DateTime? startDate = book.startDate;
      DateTime? endDate = book.endDate;
      final now = DateTime.now();

      switch (status) {
        case BookStatus.reading:
          startDate ??= now; // Define data de início se não existir
          endDate = null; // Remove data de fim
          break;
        case BookStatus.read:
          startDate ??= book.createdAt; // Define data de início se não existir
          endDate = now; // Define data de fim como agora
          break;
        case BookStatus.wantToRead:
          // Mantém as datas como estão
          break;
      }

      final updatedBook = book.copyWith(
        status: status,
        startDate: startDate,
        endDate: endDate,
        updatedAt: now,
      );

      return await updateBook(updatedBook);
    } catch (e) {
      throw Exception('Failed to update book status: $e');
    }
  }

  @override
  Future<BookEntity> updateBookProgress(String id, int currentPage) async {
    try {
      final book = await getBookById(id);
      if (book == null) {
        throw Exception('Book not found');
      }

      final updatedBook = book.copyWith(
        currentPage: currentPage,
        updatedAt: DateTime.now(),
      );

      // Se completou o livro, atualizar status
      if (currentPage >= book.totalPages && book.totalPages > 0) {
        return await updateBookStatus(id, BookStatus.read);
      }

      return await updateBook(updatedBook);
    } catch (e) {
      throw Exception('Failed to update book progress: $e');
    }
  }

  @override
  Future<BookEntity> updateBookRating(String id, double rating) async {
    try {
      final book = await getBookById(id);
      if (book == null) {
        throw Exception('Book not found');
      }

      final updatedBook = book.copyWith(
        rating: rating,
        updatedAt: DateTime.now(),
      );

      return await updateBook(updatedBook);
    } catch (e) {
      throw Exception('Failed to update book rating: $e');
    }
  }

  @override
  Future<List<BookEntity>> getBooksByStatus(BookStatus status) async {
    return await getAllBooks(status: status);
  }

  @override
  Future<List<BookEntity>> getBooksByGenre(String genre) async {
    return await getAllBooks(genre: genre);
  }

  @override
  Future<List<BookEntity>> getRecentBooks(int limit) async {
    return await getAllBooks(
      sortBy: 'created_at',
      ascending: false,
      limit: limit,
    );
  }

  @override
  Future<List<BookEntity>> getCurrentlyReading() async {
    return await getBooksByStatus(BookStatus.reading);
  }

  @override
  Future<List<BookEntity>> getFavoriteBooks() async {
    return await getAllBooks(
      sortBy: 'rating',
      ascending: false,
      limit: 20,
    );
  }

  @override
  Future<int> getBooksCount({BookStatus? status, String? genre}) async {
    try {
      return await _localDatasource.getBooksCount(
        status: status?.value,
        genre: genre,
      );
    } catch (e) {
      throw Exception('Failed to get books count: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> exportBooks() async {
    try {
      final books = await getAllBooks();
      return {
        'books': books.map((book) => BookModel.fromEntity(book).toJson()).toList(),
        'exported_at': DateTime.now().toIso8601String(),
        'total_count': books.length,
      };
    } catch (e) {
      throw Exception('Failed to export books: $e');
    }
  }

  @override
  Future<void> importBooks(Map<String, dynamic> data) async {
    try {
      final booksList = data['books'] as List<dynamic>;
      
      for (final bookData in booksList) {
        try {
          final bookModel = BookModel.fromJson(bookData as Map<String, dynamic>);
          await _localDatasource.insertBook(bookModel);
        } catch (e) {
          // Log individual book import errors but continue
          print('Failed to import book: $e');
        }
      }
    } catch (e) {
      throw Exception('Failed to import books: $e');
    }
  }

  @override
  Future<void> clearAllBooks() async {
    try {
      await _localDatasource.clearAllBooks();
    } catch (e) {
      throw Exception('Failed to clear all books: $e');
    }
  }

  @override
  Future<List<String>> getAllGenres() async {
    try {
      return await _localDatasource.getAllGenres();
    } catch (e) {
      throw Exception('Failed to get all genres: $e');
    }
  }

  @override
  Future<List<String>> getAllAuthors() async {
    try {
      return await _localDatasource.getAllAuthors();
    } catch (e) {
      throw Exception('Failed to get all authors: $e');
    }
  }

  @override
  Future<List<BookEntity>> getBooksByAuthor(String author) async {
    try {
      final models = await _localDatasource.getBooksByAuthor(author);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get books by author: $e');
    }
  }

  @override
  Future<List<BookEntity>> getBooksByYear(int year) async {
    try {
      final models = await _localDatasource.getBooksByYear(year);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get books by year: $e');
    }
  }

  @override
  Future<List<BookEntity>> getRecommendations(String bookId) async {
    try {
      // Lógica simples de recomendação baseada no gênero e avaliação
      final book = await getBookById(bookId);
      if (book == null || book.genre == null) {
        return [];
      }

      final sameGenreBooks = await getBooksByGenre(book.genre!.value);
      
      // Filtrar o próprio livro e ordenar por avaliação
      final recommendations = sameGenreBooks
          .where((b) => b.id != bookId && b.rating >= 4.0)
          .toList();
      
      recommendations.sort((a, b) => b.rating.compareTo(a.rating));
      
      return recommendations.take(5).toList();
    } catch (e) {
      throw Exception('Failed to get recommendations: $e');
    }
  }

  @override
  Future<bool> isDuplicateBook(String title, String author) async {
    try {
      return await _localDatasource.isDuplicateBook(title, author);
    } catch (e) {
      throw Exception('Failed to check duplicate book: $e');
    }
  }
}
