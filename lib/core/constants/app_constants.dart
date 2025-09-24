// 📚 FolhaVirada - App Constants
// Constantes globais da aplicação

class AppConstants {
  // App Info
  static const String appName = 'FolhaVirada';
  static const String appDescription = 'Catálogo de Livros Lidos';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'folhavirada_database.db';
  static const int databaseVersion = 1;

  // Tables
  static const String booksTable = 'books';
  static const String notesTable = 'notes';
  static const String statisticsTable = 'statistics';

  // API
  static const String googleBooksApiUrl = 'https://www.googleapis.com/books/v1';
  static const String googleBooksApiKey = '';  // Será configurado depois

  // SharedPreferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyAdCount = 'ad_count';
  static const String keyLastBackup = 'last_backup';

  // AdMob
  static const String adMobAppId = '';  // Será configurado depois
  static const String bannerAdUnitId = '';
  static const String interstitialAdUnitId = '';
  static const String rewardedAdUnitId = '';

  // UI
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double spacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double largeSpacing = 24.0;

  // Pagination
  static const int booksPerPage = 20;
  static const int searchBooksLimit = 10;

  // Image
  static const double bookCoverWidth = 120.0;
  static const double bookCoverHeight = 180.0;
  static const String placeholderBookCover = 'assets/images/book_placeholder.png';

  // Animation
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
}

// Enum para status dos livros
enum BookStatus {
  wantToRead('Quero ler', 'want_to_read'),
  reading('Lendo agora', 'reading'),
  read('Lidos', 'read');

  const BookStatus(this.label, this.value);
  final String label;
  final String value;
}

// Enum para gêneros de livros
enum BookGenre {
  fiction('Ficção', 'fiction'),
  nonFiction('Não-ficção', 'non_fiction'),
  romance('Romance', 'romance'),
  mystery('Mistério', 'mystery'),
  fantasy('Fantasia', 'fantasy'),
  scienceFiction('Ficção Científica', 'science_fiction'),
  biography('Biografia', 'biography'),
  history('História', 'history'),
  selfHelp('Autoajuda', 'self_help'),
  business('Negócios', 'business'),
  technology('Tecnologia', 'technology'),
  philosophy('Filosofia', 'philosophy'),
  psychology('Psicologia', 'psychology'),
  education('Educação', 'education'),
  health('Saúde', 'health'),
  cooking('Culinária', 'cooking'),
  travel('Viagem', 'travel'),
  art('Arte', 'art'),
  religion('Religião', 'religion'),
  other('Outro', 'other');

  const BookGenre(this.label, this.value);
  final String label;
  final String value;

  static BookGenre fromValue(String value) {
    return BookGenre.values.firstWhere(
      (genre) => genre.value == value,
      orElse: () => BookGenre.other,
    );
  }
}
