// 📚 FolhaVirada - Book Entity
// Entidade de domínio para livros

import 'package:folhavirada/core/constants/app_constants.dart';

class BookEntity {
  final String id;
  final String title;
  final String author;
  final String? publisher;
  final int? publishedYear;
  final String? isbn;
  final BookGenre? genre;
  final String? description;
  final String? coverUrl;
  final String? coverLocalPath;
  final int totalPages;
  final int currentPage;
  final BookStatus status;
  final double rating;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookEntity({
    required this.id,
    required this.title,
    required this.author,
    this.publisher,
    this.publishedYear,
    this.isbn,
    this.genre,
    this.description,
    this.coverUrl,
    this.coverLocalPath,
    this.totalPages = 0,
    this.currentPage = 0,
    this.status = BookStatus.wantToRead,
    this.rating = 0.0,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Criar cópia com alterações
  BookEntity copyWith({
    String? id,
    String? title,
    String? author,
    String? publisher,
    int? publishedYear,
    String? isbn,
    BookGenre? genre,
    String? description,
    String? coverUrl,
    String? coverLocalPath,
    int? totalPages,
    int? currentPage,
    BookStatus? status,
    double? rating,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      publishedYear: publishedYear ?? this.publishedYear,
      isbn: isbn ?? this.isbn,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      coverLocalPath: coverLocalPath ?? this.coverLocalPath,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Métodos auxiliares

  /// Calcular progresso em porcentagem
  double get progressPercentage {
    if (totalPages == 0) return 0.0;
    return (currentPage / totalPages * 100).clamp(0.0, 100.0);
  }

  /// Verificar se está em andamento
  bool get isReading => status == BookStatus.reading;

  /// Verificar se foi lido
  bool get isRead => status == BookStatus.read;

  /// Verificar se quer ler
  bool get isWantToRead => status == BookStatus.wantToRead;

  /// Verificar se tem capa
  bool get hasCover => coverUrl != null || coverLocalPath != null;

  /// Obter URL da capa (prioriza local)
  String? get effectiveCoverUrl => coverLocalPath ?? coverUrl;

  /// Verificar se tem avaliação
  bool get hasRating => rating > 0;

  /// Verificar se tem período de leitura definido
  bool get hasReadingPeriod => startDate != null && endDate != null;

  /// Calcular dias de leitura
  int? get readingDays {
    if (startDate == null || endDate == null) return null;
    return endDate!.difference(startDate!).inDays + 1;
  }

  /// Verificar se está atrasado (se for livro sendo lido há muito tempo)
  bool get isOverdue {
    if (!isReading || startDate == null) return false;
    final daysSinceStart = DateTime.now().difference(startDate!).inDays;
    return daysSinceStart > 30; // Consideramos atrasado após 30 dias
  }

  /// Obter estimativa de conclusão baseada no progresso atual
  DateTime? get estimatedFinishDate {
    if (!isReading || startDate == null || progressPercentage == 0) return null;
    
    final daysSinceStart = DateTime.now().difference(startDate!).inDays;
    if (daysSinceStart == 0) return null;
    
    final dailyProgress = progressPercentage / daysSinceStart;
    if (dailyProgress == 0) return null;
    
    final remainingProgress = 100 - progressPercentage;
    final estimatedRemainingDays = (remainingProgress / dailyProgress).ceil();
    
    return DateTime.now().add(Duration(days: estimatedRemainingDays));
  }

  /// Verificar se é um livro recente (adicionado nos últimos 7 dias)
  bool get isRecent {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return createdAt.isAfter(sevenDaysAgo);
  }

  /// Verificar se foi atualizado recentemente
  bool get isRecentlyUpdated {
    final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
    return updatedAt.isAfter(twoDaysAgo);
  }

  /// Obter cor do status
  String get statusColor {
    switch (status) {
      case BookStatus.wantToRead:
        return '#9C27B0'; // Roxo
      case BookStatus.reading:
        return '#2196F3'; // Azul
      case BookStatus.read:
        return '#4CAF50'; // Verde
    }
  }

  /// Validar se os dados do livro estão corretos
  bool get isValid {
    return title.trim().isNotEmpty &&
           author.trim().isNotEmpty &&
           totalPages >= 0 &&
           currentPage >= 0 &&
           currentPage <= totalPages &&
           rating >= 0 &&
           rating <= 5;
  }

  /// Verificar se é um livro longo (mais de 400 páginas)
  bool get isLongBook => totalPages > 400;

  /// Verificar se é um livro curto (menos de 150 páginas)
  bool get isShortBook => totalPages > 0 && totalPages < 150;

  /// Obter categoria de tamanho do livro
  String get sizeCategory {
    if (totalPages == 0) return 'Desconhecido';
    if (isShortBook) return 'Curto';
    if (isLongBook) return 'Longo';
    return 'Médio';
  }

  /// Verificar se o livro é antigo (publicado há mais de 10 anos)
  bool get isOldBook {
    if (publishedYear == null) return false;
    return DateTime.now().year - publishedYear! > 10;
  }

  /// Verificar se o livro é recente (publicado nos últimos 2 anos)
  bool get isNewBook {
    if (publishedYear == null) return false;
    return DateTime.now().year - publishedYear! <= 2;
  }

  /// Obter idade do livro em anos
  int? get bookAge {
    if (publishedYear == null) return null;
    return DateTime.now().year - publishedYear!;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'BookEntity{id: $id, title: $title, author: $author, status: ${status.label}}';
  }
}
