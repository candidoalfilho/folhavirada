// 📚 FolhaVirada - Book Remote Datasource
// Datasource para buscar livros online (Google Books API)

import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:folhavirada/core/constants/app_constants.dart';
import 'package:folhavirada/data/models/book_model.dart';
import 'package:folhavirada/core/utils/app_utils.dart';

abstract class BookRemoteDatasource {
  Future<List<BookModel>> searchBooks(String query);
  Future<BookModel?> getBookDetails(String googleBooksId);
}

@LazySingleton(as: BookRemoteDatasource)
class BookRemoteDatasourceImpl implements BookRemoteDatasource {
  final Dio _dio;

  BookRemoteDatasourceImpl(this._dio);

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    try {
      // Verificar conexão com internet
      final hasConnection = await AppUtils.hasInternetConnection();
      if (!hasConnection) {
        throw Exception('No internet connection');
      }

      final response = await _dio.get(
        '${AppConstants.googleBooksApiUrl}/volumes',
        queryParameters: {
          'q': query,
          'maxResults': AppConstants.searchBooksLimit,
          'langRestrict': 'pt', // Priorizar livros em português
          'printType': 'books',
          'orderBy': 'relevance',
          if (AppConstants.googleBooksApiKey.isNotEmpty)
            'key': AppConstants.googleBooksApiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>? ?? [];

        final books = <BookModel>[];
        for (final item in items) {
          try {
            final itemData = item as Map<String, dynamic>;
            final id = AppUtils.generateId(); // Gerar ID único local
            final book = BookModel.fromGoogleBooks(itemData, id);
            books.add(book);
          } catch (e) {
            // Log individual book parsing errors but continue
            print('Failed to parse book from Google Books: $e');
          }
        }

        return books;
      } else {
        throw Exception('Google Books API returned ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to search books online: $e');
    }
  }

  @override
  Future<BookModel?> getBookDetails(String googleBooksId) async {
    try {
      // Verificar conexão com internet
      final hasConnection = await AppUtils.hasInternetConnection();
      if (!hasConnection) {
        throw Exception('No internet connection');
      }

      final response = await _dio.get(
        '${AppConstants.googleBooksApiUrl}/volumes/$googleBooksId',
        queryParameters: {
          if (AppConstants.googleBooksApiKey.isNotEmpty)
            'key': AppConstants.googleBooksApiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final id = AppUtils.generateId(); // Gerar ID único local
        return BookModel.fromGoogleBooks(data, id);
      } else if (response.statusCode == 404) {
        return null; // Livro não encontrado
      } else {
        throw Exception('Google Books API returned ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get book details: $e');
    }
  }

  /// Buscar livros por ISBN
  Future<List<BookModel>> searchByISBN(String isbn) async {
    try {
      final cleanISBN = isbn.replaceAll(RegExp(r'[^0-9X]'), '');
      return await searchBooks('isbn:$cleanISBN');
    } catch (e) {
      throw Exception('Failed to search by ISBN: $e');
    }
  }

  /// Buscar livros por autor
  Future<List<BookModel>> searchByAuthor(String author) async {
    try {
      return await searchBooks('inauthor:$author');
    } catch (e) {
      throw Exception('Failed to search by author: $e');
    }
  }

  /// Buscar livros por título
  Future<List<BookModel>> searchByTitle(String title) async {
    try {
      return await searchBooks('intitle:$title');
    } catch (e) {
      throw Exception('Failed to search by title: $e');
    }
  }

  /// Buscar livros por categoria
  Future<List<BookModel>> searchByCategory(String category) async {
    try {
      return await searchBooks('subject:$category');
    } catch (e) {
      throw Exception('Failed to search by category: $e');
    }
  }

  /// Buscar livros populares
  Future<List<BookModel>> getPopularBooks() async {
    try {
      // Buscar por alguns termos populares em português
      final popularTerms = [
        'ficção brasileira',
        'romance',
        'autoajuda',
        'biografia',
        'história',
      ];

      final allBooks = <BookModel>[];
      
      for (final term in popularTerms) {
        try {
          final books = await searchBooks(term);
          allBooks.addAll(books.take(2)); // Pegar 2 de cada categoria
        } catch (e) {
          // Continue mesmo se uma busca falhar
          print('Failed to get popular books for term $term: $e');
        }
      }

      // Remover duplicatas baseado no título e autor
      final uniqueBooks = <BookModel>[];
      final seen = <String>{};
      
      for (final book in allBooks) {
        final key = '${book.title.toLowerCase()}_${book.author.toLowerCase()}';
        if (!seen.contains(key)) {
          seen.add(key);
          uniqueBooks.add(book);
        }
      }

      return uniqueBooks.take(AppConstants.searchBooksLimit).toList();
    } catch (e) {
      throw Exception('Failed to get popular books: $e');
    }
  }

  /// Obter informações detalhadas incluindo preview
  Future<Map<String, dynamic>?> getBookPreview(String googleBooksId) async {
    try {
      final hasConnection = await AppUtils.hasInternetConnection();
      if (!hasConnection) {
        throw Exception('No internet connection');
      }

      final response = await _dio.get(
        '${AppConstants.googleBooksApiUrl}/volumes/$googleBooksId',
        queryParameters: {
          'projection': 'full', // Obter informações completas
          if (AppConstants.googleBooksApiKey.isNotEmpty)
            'key': AppConstants.googleBooksApiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final volumeInfo = data['volumeInfo'] as Map<String, dynamic>? ?? {};
        
        return {
          'preview_link': volumeInfo['previewLink'],
          'info_link': volumeInfo['infoLink'],
          'canonical_volume_link': volumeInfo['canonicalVolumeLink'],
          'reading_modes': data['accessInfo']?['readingModes'],
          'web_reader_link': data['accessInfo']?['webReaderLink'],
        };
      }

      return null;
    } catch (e) {
      print('Failed to get book preview: $e');
      return null;
    }
  }

  /// Configurar timeout e retry policy
  void _configureDio() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'FolhaVirada/1.0.0',
      },
    );

    // Interceptor para log (apenas em desenvolvimento)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        error: true,
        logPrint: (object) => print(object),
      ),
    );

    // Interceptor para retry em caso de erro
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            // Retry uma vez em caso de timeout
            try {
              final response = await _dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
                queryParameters: error.requestOptions.queryParameters,
                data: error.requestOptions.data,
              );
              handler.resolve(response);
              return;
            } catch (e) {
              // Se o retry falhar, continue com o erro original
            }
          }
          handler.next(error);
        },
      ),
    );
  }
}
