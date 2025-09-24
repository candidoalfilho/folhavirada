// 📚 FolhaVirada - Book Repository Interface
// Interface do repositório de livros

import 'package:folhavirada/domain/entities/book_entity.dart';
import 'package:folhavirada/core/constants/app_constants.dart';

abstract class BookRepository {
  /// Obter todos os livros com filtros opcionais
  Future<List<BookEntity>> getAllBooks({
    BookStatus? status,
    String? genre,
    String? sortBy,
    bool ascending = true,
    int? limit,
    int? offset,
  });

  /// Obter livro por ID
  Future<BookEntity?> getBookById(String id);

  /// Buscar livros localmente
  Future<List<BookEntity>> searchBooks(String query);

  /// Buscar livros online (Google Books API)
  Future<List<BookEntity>> searchBooksOnline(String query);

  /// Adicionar novo livro
  Future<BookEntity> addBook(BookEntity book);

  /// Atualizar livro existente
  Future<BookEntity> updateBook(BookEntity book);

  /// Deletar livro
  Future<void> deleteBook(String id);

  /// Atualizar status do livro
  Future<BookEntity> updateBookStatus(String id, BookStatus status);

  /// Atualizar progresso de leitura
  Future<BookEntity> updateBookProgress(String id, int currentPage);

  /// Atualizar avaliação do livro
  Future<BookEntity> updateBookRating(String id, double rating);

  /// Obter livros por status
  Future<List<BookEntity>> getBooksByStatus(BookStatus status);

  /// Obter livros por gênero
  Future<List<BookEntity>> getBooksByGenre(String genre);

  /// Obter livros adicionados recentemente
  Future<List<BookEntity>> getRecentBooks(int limit);

  /// Obter livros que estão sendo lidos atualmente
  Future<List<BookEntity>> getCurrentlyReading();

  /// Obter livros favoritos (bem avaliados)
  Future<List<BookEntity>> getFavoriteBooks();

  /// Contar livros com filtros opcionais
  Future<int> getBooksCount({BookStatus? status, String? genre});

  /// Exportar todos os livros
  Future<Map<String, dynamic>> exportBooks();

  /// Importar livros de backup
  Future<void> importBooks(Map<String, dynamic> data);

  /// Limpar todos os livros
  Future<void> clearAllBooks();

  /// Obter todos os gêneros únicos
  Future<List<String>> getAllGenres();

  /// Obter todos os autores únicos
  Future<List<String>> getAllAuthors();

  /// Obter livros por autor
  Future<List<BookEntity>> getBooksByAuthor(String author);

  /// Obter livros por ano de publicação
  Future<List<BookEntity>> getBooksByYear(int year);

  /// Obter recomendações baseadas em um livro
  Future<List<BookEntity>> getRecommendations(String bookId);

  /// Verificar se é livro duplicado
  Future<bool> isDuplicateBook(String title, String author);
}
