// 📚 FolhaVirada - Book Constants
// Constantes relacionadas a livros (status, gêneros, etc.)

enum BookStatus {
  wantToRead('Quero Ler', 'want_to_read'),
  reading('Lendo Agora', 'reading'),
  read('Lido', 'read');

  const BookStatus(this.label, this.value);
  final String label;
  final String value;
}

enum BookGenre {
  fiction('Ficção', 'fiction'),
  nonFiction('Não-ficção', 'non_fiction'),
  fantasy('Fantasia', 'fantasy'),
  scienceFiction('Ficção Científica', 'science_fiction'),
  mystery('Mistério', 'mystery'),
  thriller('Thriller', 'thriller'),
  romance('Romance', 'romance'),
  biography('Biografia', 'biography'),
  history('História', 'history'),
  selfHelp('Autoajuda', 'self_help'),
  business('Negócios', 'business'),
  health('Saúde', 'health'),
  travel('Viagem', 'travel'),
  cooking('Culinária', 'cooking'),
  art('Arte', 'art'),
  music('Música', 'music'),
  sports('Esportes', 'sports'),
  religion('Religião', 'religion'),
  philosophy('Filosofia', 'philosophy'),
  psychology('Psicologia', 'psychology'),
  education('Educação', 'education'),
  technology('Tecnologia', 'technology'),
  children('Infantil', 'children'),
  youngAdult('Jovem Adulto', 'young_adult'),
  poetry('Poesia', 'poetry'),
  drama('Drama', 'drama'),
  comedy('Comédia', 'comedy'),
  adventure('Aventura', 'adventure'),
  horror('Horror', 'horror'),
  other('Outro', 'other');

  const BookGenre(this.label, this.value);
  final String label;
  final String value;
}

class BookConstants {
  // Limites de validação
  static const int minTitleLength = 1;
  static const int maxTitleLength = 200;
  static const int minAuthorLength = 1;
  static const int maxAuthorLength = 100;
  static const int minYear = 1000;
  static const int maxYear = 2100;
  static const int minPages = 1;
  static const int maxPages = 10000;
  static const int maxDescriptionLength = 1000;
  static const int maxNotesLength = 2000;

  // Ratings
  static const double minRating = 0.0;
  static const double maxRating = 5.0;
  static const double ratingStep = 0.5;

  // Default values
  static const String defaultStatus = 'want_to_read';
  static const String defaultGenre = 'other';
}
