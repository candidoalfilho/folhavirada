// 📚 FolhaVirada - App Routes
// Sistema de navegação e rotas da aplicação

import 'package:flutter/material.dart';
import 'package:folhavirada/presentation/screens/book/books_by_author_screen.dart';
import 'package:folhavirada/presentation/screens/book/books_by_genre_screen.dart';
import 'package:folhavirada/presentation/screens/book/books_by_status_screen.dart';
import 'package:folhavirada/presentation/screens/book/edit_book_screen.dart';
import 'package:folhavirada/presentation/screens/book/search_books_screen.dart';
import 'package:folhavirada/presentation/screens/home/home_screen.dart';
import 'package:folhavirada/presentation/screens/book_detail/book_detail_screen.dart';
import 'package:folhavirada/presentation/screens/stats/stats_screen.dart';
import 'package:folhavirada/presentation/screens/settings/settings_screen.dart';
import 'package:folhavirada/presentation/screens/book/add_book_screen.dart';
import 'package:folhavirada/presentation/screens/theme/theme_screen.dart';
import 'package:folhavirada/presentation/screens/about/about_screen.dart';
import 'package:folhavirada/core/utils/app_utils.dart';
import 'package:folhavirada/presentation/screens/theme/theme_screen.dart';
import 'package:folhavirada/presentation/screens/notes/notes_screen.dart';
import 'package:folhavirada/presentation/screens/notes/add_note_screen.dart';
import 'package:folhavirada/presentation/screens/notes/edit_note_screen.dart';
import 'package:folhavirada/presentation/screens/theme/theme_screen.dart';
import 'package:folhavirada/presentation/screens/about/about_screen.dart';
import 'package:folhavirada/presentation/screens/notes/notes_screen.dart';
import 'package:folhavirada/presentation/screens/notes/add_note_screen.dart';
import 'package:folhavirada/presentation/screens/notes/edit_note_screen.dart';
import 'package:folhavirada/presentation/screens/theme/theme_screen.dart';
import 'package:folhavirada/presentation/screens/about/about_screen.dart';
import 'package:folhavirada/presentation/screens/notes/notes_screen.dart';
import 'package:folhavirada/presentation/screens/notes/add_note_screen.dart';
import 'package:folhavirada/presentation/screens/notes/edit_note_screen.dart';
import 'package:folhavirada/presentation/screens/theme/theme_screen.dart';
import 'package:folhavirada/presentation/screens/about/about_screen.dart';
import 'package:folhavirada/presentation/screens/notes/notes_screen.dart';
import 'package:folhavirada/presentation/screens/notes/add_note_screen.dart';
import 'package:folhavirada/presentation/screens/notes/edit_note_screen.dart';
import 'package:folhavirada/presentation/screens/theme/theme_screen.dart';
import 'package:folhavirada/presentation/screens/about/about_screen.dart';
import 'package:folhavirada/presentation/screens/notes/notes_screen.dart';
import 'package:folhavirada/presentation/screens/notes/add_note_screen.dart';
import 'package:folhavirada/presentation/screens/notes/edit_note_screen.dart';
import 'package:folhavirada/presentation/screens/theme/theme_screen.dart';
import 'package:folhavirada/presentation/screens/about/about_screen.dart';

class AppRoutes {
  // Nomes das rotas
  static const String home = '/';
  static const String bookDetail = '/book-detail';
  static const String addBook = '/add-book';
  static const String editBook = '/edit-book';
  static const String searchBooks = '/search-books';
  static const String searchOnline = '/search-online';
  static const String stats = '/stats';
  static const String settings = '/settings';
  static const String notes = '/notes';
  static const String addNote = '/add-note';
  static const String editNote = '/edit-note';
  static const String booksByStatus = '/books-by-status';
  static const String booksByGenre = '/books-by-genre';
  static const String booksByAuthor = '/books-by-author';
  static const String export = '/export';
  static const String import = '/import';
  static const String about = '/about';

  // Gerador de rotas
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    final routeName = settings.name;

    if (routeName == home) {
      return _createRoute(const HomeScreen());
    } else if (routeName == bookDetail) {
      final bookId = args?['bookId'] as String?;
      if (bookId == null) {
        return _createErrorRoute('Book ID is required');
      }
      return _createRoute(BookDetailScreen(bookId: bookId));
    } else if (routeName == addBook) {
      final bookData = args?['bookData'] as Map<String, dynamic>?;
      return _createRoute(AddBookScreen(initialData: bookData));
    } else if (routeName == editBook) {
      final bookId = args?['bookId'] as String?;
      if (bookId == null) {
        return _createErrorRoute('Book ID is required');
      }
      return _createRoute(EditBookScreen(bookId: bookId));
    } else if (routeName == searchBooks) {
      final initialQuery = args?['query'] as String?;
      return _createRoute(SearchBooksScreen(initialQuery: initialQuery));
    // Busca online removida temporariamente
    } else if (routeName == stats) {
      return _createRoute(const StatsScreen());
    } else if (routeName == settings) {
      return _createRoute(const SettingsScreen());
    } else if (routeName == notes) {
      final bookId = args?['bookId'] as String?;
      if (bookId == null) {
        return _createErrorRoute('Book ID is required');
      }
      return _createRoute(NotesScreen(bookId: bookId));
    } else if (routeName == addNote) {
      final bookId = args?['bookId'] as String?;
      if (bookId == null) {
        return _createErrorRoute('Book ID is required');
      }
      final pageNumber = args?['pageNumber'] as int?;
      return _createRoute(AddNoteScreen(bookId: bookId, pageNumber: pageNumber));
    } else if (routeName == editNote) {
      final noteId = args?['noteId'] as String?;
      if (noteId == null) {
        return _createErrorRoute('Note ID is required');
      }
      return _createRoute(EditNoteScreen(noteId: noteId));
    } else if (routeName == booksByStatus) {
      final status = args?['status'] as String?;
      if (status == null) {
        return _createErrorRoute('Status is required');
      }
      return _createRoute(BooksByStatusScreen(status: status));
    } else if (routeName == booksByGenre) {
      final genre = args?['genre'] as String?;
      if (genre == null) {
        return _createErrorRoute('Genre is required');
      }
      return _createRoute(BooksByGenreScreen(genre: genre));
    } else if (routeName == booksByAuthor) {
      final author = args?['author'] as String?;
      if (author == null) {
        return _createErrorRoute('Author is required');
      }
      return _createRoute(BooksByAuthorScreen(author: author));
    } else if (routeName == about) {
      return _createRoute(const AboutScreen());
    } else if (routeName == '/theme') {
      return _createRoute(const ThemeScreen());
    } else {
      return _createErrorRoute('Route not found: ${settings.name}');
    }
  }

  // Criar rota com animação personalizada
  static PageRoute<T> _createRoute<T extends Object?>(Widget page) {
    return AppUtils.createPageRoute(page) as PageRoute<T>;
  }

  // Criar rota de erro
  static Route<dynamic> _createErrorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Erro de Navegação',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  home,
                  (route) => false,
                ),
                child: const Text('Voltar ao Início'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extensões para navegação mais fácil
extension NavigationExtensions on BuildContext {
  // Navegar para rota
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    return Navigator.of(this).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  // Navegar e remover todas as rotas anteriores
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  // Substituir rota atual
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
    TO? result,
  }) {
    return Navigator.of(this).pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  // Voltar
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  // Verificar se pode voltar
  bool canPop() {
    return Navigator.of(this).canPop();
  }

  // Navegar para detalhes do livro
  Future<void> goToBookDetail(String bookId) {
    return pushNamed(AppRoutes.bookDetail, arguments: {'bookId': bookId});
  }

  // Navegar para adicionar livro
  Future<void> goToAddBook([Map<String, dynamic>? bookData]) {
    return pushNamed(AppRoutes.addBook, arguments: {'bookData': bookData});
  }

  // Navegar para editar livro
  Future<void> goToEditBook(String bookId) {
    return pushNamed(AppRoutes.editBook, arguments: {'bookId': bookId});
  }

  // Navegar para busca de livros
  Future<void> goToSearchBooks([String? query]) {
    return pushNamed(AppRoutes.searchBooks, arguments: {'query': query});
  }

  // Busca online removida temporariamente
  // Future<void> goToSearchOnline([String? query]) {
  //   return pushNamed(AppRoutes.searchOnline, arguments: {'query': query});
  // }

  // Navegar para estatísticas
  Future<void> goToStats() {
    return pushNamed(AppRoutes.stats);
  }

  // Navegar para configurações
  Future<void> goToSettings() {
    return pushNamed(AppRoutes.settings);
  }

  // Navegar para notas do livro
  Future<void> goToNotes(String bookId) {
    return pushNamed(AppRoutes.notes, arguments: {'bookId': bookId});
  }

  // Navegar para adicionar nota
  Future<void> goToAddNote(String bookId, [int? pageNumber]) {
    return pushNamed(AppRoutes.addNote, arguments: {
      'bookId': bookId,
      'pageNumber': pageNumber,
    });
  }

  // Navegar para editar nota
  Future<void> goToEditNote(String noteId) {
    return pushNamed(AppRoutes.editNote, arguments: {'noteId': noteId});
  }

  // Navegar para livros por status
  Future<void> goToBooksByStatus(String status) {
    return pushNamed(AppRoutes.booksByStatus, arguments: {'status': status});
  }

  // Navegar para livros por gênero
  Future<void> goToBooksByGenre(String genre) {
    return pushNamed(AppRoutes.booksByGenre, arguments: {'genre': genre});
  }

  // Navegar para livros por autor
  Future<void> goToBooksByAuthor(String author) {
    return pushNamed(AppRoutes.booksByAuthor, arguments: {'author': author});
  }

  // Nova extensão para tema
  Future<void> goToTheme() {
    return pushNamed('/theme');
  }

  // Navegar para exportar dados
  Future<void> goToExport() {
    return pushNamed(AppRoutes.export);
  }

  // Navegar para importar dados
  Future<void> goToImport() {
    return pushNamed(AppRoutes.import);
  }

  // Navegar para sobre
  Future<void> goToAbout() {
    return pushNamed(AppRoutes.about);
  }
}
