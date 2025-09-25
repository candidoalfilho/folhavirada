// 📚 FolhaVirada - Hive Book Model
// Modelo de dados para persistência local com Hive

import 'package:hive/hive.dart';
import 'package:folhavirada/domain/entities/book_entity.dart';
import 'package:folhavirada/core/constants/app_constants.dart';

part 'hive_book_model.g.dart';

@HiveType(typeId: 0)
class HiveBookModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String author;

  @HiveField(3)
  String? publisher;

  @HiveField(4)
  int? publishedYear;

  @HiveField(5)
  String? isbn;

  @HiveField(6)
  int? totalPages;

  @HiveField(7)
  int? currentPage;

  @HiveField(8)
  String? genre;

  @HiveField(9)
  String? description;

  @HiveField(10)
  String status; // 'want_to_read', 'reading', 'read'

  @HiveField(11)
  double? rating;

  @HiveField(12)
  DateTime? startDate;

  @HiveField(13)
  DateTime? endDate;

  @HiveField(14)
  String? coverLocalPath;

  @HiveField(15)
  String? coverUrl;

  @HiveField(16)
  DateTime createdAt;

  @HiveField(17)
  DateTime updatedAt;

  @HiveField(18)
  bool isFavorite;

  @HiveField(19)
  List<String>? tags;

  @HiveField(20)
  String? language;

  HiveBookModel({
    required this.id,
    required this.title,
    required this.author,
    this.publisher,
    this.publishedYear,
    this.isbn,
    this.totalPages,
    this.currentPage,
    this.genre,
    this.description,
    this.status = 'want_to_read',
    this.rating,
    this.startDate,
    this.endDate,
    this.coverLocalPath,
    this.coverUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.tags,
    this.language,
  });

  // Convert to domain entity
  BookEntity toEntity() {
    return BookEntity(
      id: id,
      title: title,
      author: author,
      publisher: publisher,
      publishedYear: publishedYear,
      isbn: isbn,
      totalPages: totalPages,
      currentPage: currentPage,
      genre: genre,
      description: description,
      status: status,
      rating: rating,
      startDate: startDate,
      endDate: endDate,
      coverLocalPath: coverLocalPath,
      coverUrl: coverUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isFavorite: isFavorite,
      tags: tags,
      language: language,
    );
  }

  // Create from domain entity
  factory HiveBookModel.fromEntity(BookEntity entity) {
    return HiveBookModel(
      id: entity.id,
      title: entity.title,
      author: entity.author,
      publisher: entity.publisher,
      publishedYear: entity.publishedYear,
      isbn: entity.isbn,
      totalPages: entity.totalPages,
      currentPage: entity.currentPage,
      genre: entity.genre,
      description: entity.description,
      status: entity.status,
      rating: entity.rating,
      startDate: entity.startDate,
      endDate: entity.endDate,
      coverLocalPath: entity.coverLocalPath,
      coverUrl: entity.coverUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isFavorite: entity.isFavorite,
      tags: entity.tags,
      language: entity.language,
    );
  }

  // Helper methods
  double get progress {
    if (totalPages == null || totalPages! <= 0) return 0.0;
    if (currentPage == null || currentPage! <= 0) return 0.0;
    return (currentPage! / totalPages!).clamp(0.0, 1.0);
  }

  bool get isCompleted => status == 'read';
  bool get isReading => status == 'reading';
  bool get isWantToRead => status == 'want_to_read';

  int? get readingDays {
    if (startDate == null) return null;
    final endDateToUse = endDate ?? DateTime.now();
    return endDateToUse.difference(startDate!).inDays;
  }

  // Copy with method
  HiveBookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? publisher,
    int? publishedYear,
    String? isbn,
    int? totalPages,
    int? currentPage,
    String? genre,
    String? description,
    String? status,
    double? rating,
    DateTime? startDate,
    DateTime? endDate,
    String? coverImagePath,
    String? coverImageUrl,
    DateTime? dateAdded,
    DateTime? dateModified,
    bool? isFavorite,
    List<String>? tags,
    String? language,
  }) {
    return HiveBookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      publishedYear: publishedYear ?? this.publishedYear,
      isbn: isbn ?? this.isbn,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      dateAdded: dateAdded ?? this.dateAdded,
      dateModified: dateModified ?? DateTime.now(),
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      language: language ?? this.language,
    );
  }

  @override
  String toString() {
    return 'HiveBookModel(id: $id, title: $title, author: $author, status: $status)';
  }
}
