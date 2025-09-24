// 📚 FolhaVirada - Book Use Cases
// Casos de uso para operações com livros

import 'package:injectable/injectable.dart';
import 'package:folhavirada/domain/entities/book_entity.dart';
import 'package:folhavirada/domain/repositories/book_repository.dart';
import 'package:folhavirada/core/constants/app_constants.dart';
import 'package:folhavirada/core/utils/app_utils.dart';

// Use Case base
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// Parâmetros para diferentes use cases
class GetAllBooksParams {
  final BookStatus? status;
  final String? genre;
  final String? sortBy;
  final bool ascending;
  final int? limit;
  final int? offset;

  const GetAllBooksParams({
    this.status,
    this.genre,
    this.sortBy,
    this.ascending = true,
    this.limit,
    this.offset,
  });
}

class AddBookParams {
  final String title;
  final String author;
  final String? publisher;
  final int? publishedYear;
  final String? isbn;
  final BookGenre? genre;
  final String? description;
  final String? coverUrl;
  final int totalPages;
  final BookStatus status;

  const AddBookParams({
    required this.title,
    required this.author,
    this.publisher,
    this.publishedYear,
    this.isbn,
    this.genre,
    this.description,
    this.coverUrl,
    this.totalPages = 0,
    this.status = BookStatus.wantToRead,
  });
}

class UpdateBookProgressParams {
  final String bookId;
  final int currentPage;

  const UpdateBookProgressParams({
    required this.bookId,
    required this.currentPage,
  });
}

class UpdateBookStatusParams {
  final String bookId;
  final BookStatus status;

  const UpdateBookStatusParams({
    required this.bookId,
    required this.status,
  });
}

class UpdateBookRatingParams {
  final String bookId;
  final double rating;

  const UpdateBookRatingParams({
    required this.bookId,
    required this.rating,
  });
}

// Use Cases

@injectable
class GetAllBooksUseCase implements UseCase<List<BookEntity>, GetAllBooksParams> {
  final BookRepository _repository;

  GetAllBooksUseCase(this._repository);

  @override
  Future<List<BookEntity>> call(GetAllBooksParams params) async {
    return await _repository.getAllBooks(
      status: params.status,
      genre: params.genre,
      sortBy: params.sortBy,
      ascending: params.ascending,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

@injectable
class GetBookByIdUseCase implements UseCase<BookEntity?, String> {
  final BookRepository _repository;

  GetBookByIdUseCase(this._repository);

  @override
  Future<BookEntity?> call(String bookId) async {
    if (bookId.trim().isEmpty) {
      throw ArgumentError('Book ID cannot be empty');
    }
    return await _repository.getBookById(bookId);
  }
}

@injectable
class SearchBooksUseCase implements UseCase<List<BookEntity>, String> {
  final BookRepository _repository;

  SearchBooksUseCase(this._repository);

  @override
  Future<List<BookEntity>> call(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await _repository.searchBooks(query.trim());
  }
}

@injectable
class SearchBooksOnlineUseCase implements UseCase<List<BookEntity>, String> {
  final BookRepository _repository;

  SearchBooksOnlineUseCase(this._repository);

  @override
  Future<List<BookEntity>> call(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    // Verificar conexão com internet
    final hasConnection = await AppUtils.hasInternetConnection();
    if (!hasConnection) {
      throw Exception('Internet connection required');
    }

    return await _repository.searchBooksOnline(query.trim());
  }
}

@injectable
class AddBookUseCase implements UseCase<BookEntity, AddBookParams> {
  final BookRepository _repository;

  AddBookUseCase(this._repository);

  @override
  Future<BookEntity> call(AddBookParams params) async {
    // Validar dados obrigatórios
    if (params.title.trim().isEmpty) {
      throw ArgumentError('Book title cannot be empty');
    }
    if (params.author.trim().isEmpty) {
      throw ArgumentError('Book author cannot be empty');
    }

    // Verificar duplicatas
    final isDuplicate = await _repository.isDuplicateBook(
      params.title.trim(),
      params.author.trim(),
    );
    if (isDuplicate) {
      throw Exception('Book already exists in library');
    }

    // Criar entidade do livro
    final now = DateTime.now();
    final book = BookEntity(
      id: AppUtils.generateId(),
      title: params.title.trim(),
      author: params.author.trim(),
      publisher: params.publisher?.trim(),
      publishedYear: params.publishedYear,
      isbn: params.isbn?.trim(),
      genre: params.genre,
      description: params.description?.trim(),
      coverUrl: params.coverUrl?.trim(),
      totalPages: params.totalPages,
      status: params.status,
      createdAt: now,
      updatedAt: now,
    );

    return await _repository.addBook(book);
  }
}

@injectable
class UpdateBookUseCase implements UseCase<BookEntity, BookEntity> {
  final BookRepository _repository;

  UpdateBookUseCase(this._repository);

  @override
  Future<BookEntity> call(BookEntity book) async {
    // Validar dados obrigatórios
    if (book.title.trim().isEmpty) {
      throw ArgumentError('Book title cannot be empty');
    }
    if (book.author.trim().isEmpty) {
      throw ArgumentError('Book author cannot be empty');
    }

    // Atualizar timestamp
    final updatedBook = book.copyWith(updatedAt: DateTime.now());
    return await _repository.updateBook(updatedBook);
  }
}

@injectable
class DeleteBookUseCase implements UseCase<void, String> {
  final BookRepository _repository;

  DeleteBookUseCase(this._repository);

  @override
  Future<void> call(String bookId) async {
    if (bookId.trim().isEmpty) {
      throw ArgumentError('Book ID cannot be empty');
    }

    // Verificar se o livro existe
    final book = await _repository.getBookById(bookId);
    if (book == null) {
      throw Exception('Book not found');
    }

    await _repository.deleteBook(bookId);
  }
}

@injectable
class UpdateBookProgressUseCase implements UseCase<BookEntity, UpdateBookProgressParams> {
  final BookRepository _repository;

  UpdateBookProgressUseCase(this._repository);

  @override
  Future<BookEntity> call(UpdateBookProgressParams params) async {
    if (params.bookId.trim().isEmpty) {
      throw ArgumentError('Book ID cannot be empty');
    }
    if (params.currentPage < 0) {
      throw ArgumentError('Current page cannot be negative');
    }

    // Verificar se o livro existe
    final book = await _repository.getBookById(params.bookId);
    if (book == null) {
      throw Exception('Book not found');
    }

    // Validar progresso
    if (book.totalPages > 0 && params.currentPage > book.totalPages) {
      throw ArgumentError('Current page cannot exceed total pages');
    }

    return await _repository.updateBookProgress(params.bookId, params.currentPage);
  }
}

@injectable
class UpdateBookStatusUseCase implements UseCase<BookEntity, UpdateBookStatusParams> {
  final BookRepository _repository;

  UpdateBookStatusUseCase(this._repository);

  @override
  Future<BookEntity> call(UpdateBookStatusParams params) async {
    if (params.bookId.trim().isEmpty) {
      throw ArgumentError('Book ID cannot be empty');
    }

    // Verificar se o livro existe
    final book = await _repository.getBookById(params.bookId);
    if (book == null) {
      throw Exception('Book not found');
    }

    return await _repository.updateBookStatus(params.bookId, params.status);
  }
}

@injectable
class UpdateBookRatingUseCase implements UseCase<BookEntity, UpdateBookRatingParams> {
  final BookRepository _repository;

  UpdateBookRatingUseCase(this._repository);

  @override
  Future<BookEntity> call(UpdateBookRatingParams params) async {
    if (params.bookId.trim().isEmpty) {
      throw ArgumentError('Book ID cannot be empty');
    }
    if (params.rating < 0 || params.rating > 5) {
      throw ArgumentError('Rating must be between 0 and 5');
    }

    // Verificar se o livro existe
    final book = await _repository.getBookById(params.bookId);
    if (book == null) {
      throw Exception('Book not found');
    }

    return await _repository.updateBookRating(params.bookId, params.rating);
  }
}

@injectable
class GetBooksByStatusUseCase implements UseCase<List<BookEntity>, BookStatus> {
  final BookRepository _repository;

  GetBooksByStatusUseCase(this._repository);

  @override
  Future<List<BookEntity>> call(BookStatus status) async {
    return await _repository.getBooksByStatus(status);
  }
}

@injectable
class GetCurrentlyReadingUseCase implements UseCase<List<BookEntity>, void> {
  final BookRepository _repository;

  GetCurrentlyReadingUseCase(this._repository);

  @override
  Future<List<BookEntity>> call(void params) async {
    return await _repository.getCurrentlyReading();
  }
}

@injectable
class GetRecentBooksUseCase implements UseCase<List<BookEntity>, int> {
  final BookRepository _repository;

  GetRecentBooksUseCase(this._repository);

  @override
  Future<List<BookEntity>> call(int limit) async {
    if (limit <= 0) {
      throw ArgumentError('Limit must be greater than 0');
    }
    return await _repository.getRecentBooks(limit);
  }
}

@injectable
class GetFavoriteBooksUseCase implements UseCase<List<BookEntity>, void> {
  final BookRepository _repository;

  GetFavoriteBooksUseCase(this._repository);

  @override
  Future<List<BookEntity>> call(void params) async {
    return await _repository.getFavoriteBooks();
  }
}

@injectable
class GetBooksCountUseCase implements UseCase<int, GetAllBooksParams> {
  final BookRepository _repository;

  GetBooksCountUseCase(this._repository);

  @override
  Future<int> call(GetAllBooksParams params) async {
    return await _repository.getBooksCount(
      status: params.status,
      genre: params.genre,
    );
  }
}

@injectable
class ExportBooksUseCase implements UseCase<Map<String, dynamic>, void> {
  final BookRepository _repository;

  ExportBooksUseCase(this._repository);

  @override
  Future<Map<String, dynamic>> call(void params) async {
    return await _repository.exportBooks();
  }
}

@injectable
class ImportBooksUseCase implements UseCase<void, Map<String, dynamic>> {
  final BookRepository _repository;

  ImportBooksUseCase(this._repository);

  @override
  Future<void> call(Map<String, dynamic> data) async {
    if (data.isEmpty) {
      throw ArgumentError('Import data cannot be empty');
    }
    await _repository.importBooks(data);
  }
}

@injectable
class ClearAllBooksUseCase implements UseCase<void, void> {
  final BookRepository _repository;

  ClearAllBooksUseCase(this._repository);

  @override
  Future<void> call(void params) async {
    await _repository.clearAllBooks();
  }
}

@injectable
class GetAllGenresUseCase implements UseCase<List<String>, void> {
  final BookRepository _repository;

  GetAllGenresUseCase(this._repository);

  @override
  Future<List<String>> call(void params) async {
    return await _repository.getAllGenres();
  }
}

@injectable
class GetAllAuthorsUseCase implements UseCase<List<String>, void> {
  final BookRepository _repository;

  GetAllAuthorsUseCase(this._repository);

  @override
  Future<List<String>> call(void params) async {
    return await _repository.getAllAuthors();
  }
}

@injectable
class GetRecommendationsUseCase implements UseCase<List<BookEntity>, String> {
  final BookRepository _repository;

  GetRecommendationsUseCase(this._repository);

  @override
  Future<List<BookEntity>> call(String bookId) async {
    if (bookId.trim().isEmpty) {
      throw ArgumentError('Book ID cannot be empty');
    }
    return await _repository.getRecommendations(bookId);
  }
}

// Use case composto para operações complexas
@injectable
class StartReadingBookUseCase implements UseCase<BookEntity, String> {
  final UpdateBookStatusUseCase _updateStatusUseCase;
  final GetBookByIdUseCase _getBookUseCase;

  StartReadingBookUseCase(
    this._updateStatusUseCase,
    this._getBookUseCase,
  );

  @override
  Future<BookEntity> call(String bookId) async {
    // Verificar se o livro existe
    final book = await _getBookUseCase(bookId);
    if (book == null) {
      throw Exception('Book not found');
    }

    // Não permitir iniciar leitura de livro já lido
    if (book.isRead) {
      throw Exception('Cannot start reading a book that is already read');
    }

    return await _updateStatusUseCase(
      UpdateBookStatusParams(bookId: bookId, status: BookStatus.reading),
    );
  }
}

@injectable
class FinishReadingBookUseCase implements UseCase<BookEntity, String> {
  final UpdateBookStatusUseCase _updateStatusUseCase;
  final UpdateBookProgressUseCase _updateProgressUseCase;
  final GetBookByIdUseCase _getBookUseCase;

  FinishReadingBookUseCase(
    this._updateStatusUseCase,
    this._updateProgressUseCase,
    this._getBookUseCase,
  );

  @override
  Future<BookEntity> call(String bookId) async {
    // Verificar se o livro existe
    final book = await _getBookUseCase(bookId);
    if (book == null) {
      throw Exception('Book not found');
    }

    // Atualizar progresso para 100% se necessário
    if (book.totalPages > 0 && book.currentPage < book.totalPages) {
      await _updateProgressUseCase(
        UpdateBookProgressParams(
          bookId: bookId,
          currentPage: book.totalPages,
        ),
      );
    }

    // Marcar como lido
    return await _updateStatusUseCase(
      UpdateBookStatusParams(bookId: bookId, status: BookStatus.read),
    );
  }
}
