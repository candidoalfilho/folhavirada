// 📚 FolhaVirada - Book Model
// Modelo de dados para livros

import 'package:json_annotation/json_annotation.dart';
import 'package:folhavirada/core/constants/app_constants.dart';
import 'package:folhavirada/domain/entities/book_entity.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookModel {
  final String id;
  final String title;
  final String author;
  final String? publisher;
  final int? publishedYear;
  final String? isbn;
  final String? genre;
  final String? description;
  final String? coverUrl;
  final String? coverLocalPath;
  final int totalPages;
  final int currentPage;
  final String status;
  final double rating;
  final String? startDate;
  final String? endDate;
  final String createdAt;
  final String updatedAt;

  const BookModel({
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
    this.status = 'want_to_read',
    this.rating = 0.0,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor para JSON
  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  /// Converter para JSON
  Map<String, dynamic> toJson() => _$BookModelToJson(this);

  /// Factory constructor para banco de dados
  factory BookModel.fromDatabase(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      publisher: map['publisher'] as String?,
      publishedYear: map['published_year'] as int?,
      isbn: map['isbn'] as String?,
      genre: map['genre'] as String?,
      description: map['description'] as String?,
      coverUrl: map['cover_url'] as String?,
      coverLocalPath: map['cover_local_path'] as String?,
      totalPages: map['total_pages'] as int? ?? 0,
      currentPage: map['current_page'] as int? ?? 0,
      status: map['status'] as String? ?? 'want_to_read',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      startDate: map['start_date'] as String?,
      endDate: map['end_date'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  /// Converter para mapa do banco de dados
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publisher': publisher,
      'published_year': publishedYear,
      'isbn': isbn,
      'genre': genre,
      'description': description,
      'cover_url': coverUrl,
      'cover_local_path': coverLocalPath,
      'total_pages': totalPages,
      'current_page': currentPage,
      'status': status,
      'rating': rating,
      'start_date': startDate,
      'end_date': endDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Factory constructor para Google Books API
  factory BookModel.fromGoogleBooks(Map<String, dynamic> json, String id) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>? ?? {};
    final industryIdentifiers = volumeInfo['industryIdentifiers'] as List? ?? [];
    
    // Extrair ISBN
    String? isbn;
    for (final identifier in industryIdentifiers) {
      if (identifier['type'] == 'ISBN_13' || identifier['type'] == 'ISBN_10') {
        isbn = identifier['identifier'];
        break;
      }
    }

    // Extrair autores
    final authors = volumeInfo['authors'] as List?;
    final author = authors?.isNotEmpty == true 
        ? authors!.join(', ') 
        : 'Autor desconhecido';

    // Extrair categorias (gênero)
    final categories = volumeInfo['categories'] as List?;
    final genre = categories?.isNotEmpty == true ? categories!.first : null;

    final now = DateTime.now().toIso8601String();

    return BookModel(
      id: id,
      title: volumeInfo['title'] as String? ?? 'Título desconhecido',
      author: author,
      publisher: volumeInfo['publisher'] as String?,
      publishedYear: _extractYear(volumeInfo['publishedDate'] as String?),
      isbn: isbn,
      genre: genre,
      description: volumeInfo['description'] as String?,
      coverUrl: imageLinks['thumbnail'] as String?,
      totalPages: volumeInfo['pageCount'] as int? ?? 0,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Converter para entidade do domínio
  BookEntity toEntity() {
    return BookEntity(
      id: id,
      title: title,
      author: author,
      publisher: publisher,
      publishedYear: publishedYear,
      isbn: isbn,
      genre: genre != null ? BookGenre.fromValue(genre!) : null,
      description: description,
      coverUrl: coverUrl,
      coverLocalPath: coverLocalPath,
      totalPages: totalPages,
      currentPage: currentPage,
      status: BookStatus.values.firstWhere(
        (s) => s.value == status,
        orElse: () => BookStatus.wantToRead,
      ),
      rating: rating,
      startDate: startDate != null ? DateTime.tryParse(startDate!) : null,
      endDate: endDate != null ? DateTime.tryParse(endDate!) : null,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  /// Factory constructor da entidade do domínio
  factory BookModel.fromEntity(BookEntity entity) {
    return BookModel(
      id: entity.id,
      title: entity.title,
      author: entity.author,
      publisher: entity.publisher,
      publishedYear: entity.publishedYear,
      isbn: entity.isbn,
      genre: entity.genre?.value,
      description: entity.description,
      coverUrl: entity.coverUrl,
      coverLocalPath: entity.coverLocalPath,
      totalPages: entity.totalPages,
      currentPage: entity.currentPage,
      status: entity.status.value,
      rating: entity.rating,
      startDate: entity.startDate?.toIso8601String(),
      endDate: entity.endDate?.toIso8601String(),
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }

  /// Criar cópia com alterações
  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? publisher,
    int? publishedYear,
    String? isbn,
    String? genre,
    String? description,
    String? coverUrl,
    String? coverLocalPath,
    int? totalPages,
    int? currentPage,
    String? status,
    double? rating,
    String? startDate,
    String? endDate,
    String? createdAt,
    String? updatedAt,
  }) {
    return BookModel(
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
  bool get isReading => status == BookStatus.reading.value;

  /// Verificar se foi lido
  bool get isRead => status == BookStatus.read.value;

  /// Verificar se quer ler
  bool get isWantToRead => status == BookStatus.wantToRead.value;

  /// Obter status como enum
  BookStatus get statusEnum {
    return BookStatus.values.firstWhere(
      (s) => s.value == status,
      orElse: () => BookStatus.wantToRead,
    );
  }

  /// Obter gênero como enum
  BookGenre? get genreEnum {
    return genre != null ? BookGenre.fromValue(genre!) : null;
  }

  /// Verificar se tem capa
  bool get hasCover => coverUrl != null || coverLocalPath != null;

  /// Obter URL da capa (prioriza local)
  String? get effectiveCoverUrl => coverLocalPath ?? coverUrl;

  /// Métodos auxiliares estáticos
  static int? _extractYear(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    
    // Tentar extrair ano de diferentes formatos
    final patterns = [
      RegExp(r'^(\d{4})'),           // 2023, 2023-01, 2023-01-01
      RegExp(r'(\d{4})'),            // Qualquer sequência de 4 dígitos
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(dateString);
      if (match != null) {
        final year = int.tryParse(match.group(1)!);
        if (year != null && year >= 1000 && year <= DateTime.now().year + 10) {
          return year;
        }
      }
    }

    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'BookModel{id: $id, title: $title, author: $author, status: $status}';
  }
}
