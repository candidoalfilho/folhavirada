// 📚 FolhaVirada - Simple Hive Book Model
// Modelo simplificado para Hive

import 'package:hive/hive.dart';

part 'simple_hive_book.g.dart';

@HiveType(typeId: 0)
class SimpleHiveBook extends HiveObject {
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
  String? genre;

  @HiveField(7)
  String? description;

  @HiveField(8)
  String? coverUrl;

  @HiveField(9)
  String? coverLocalPath;

  @HiveField(10)
  int totalPages;

  @HiveField(11)
  int currentPage;

  @HiveField(12)
  String status; // 'wantToRead', 'reading', 'read'

  @HiveField(13)
  double rating;

  @HiveField(14)
  DateTime? startDate;

  @HiveField(15)
  DateTime? endDate;

  @HiveField(16)
  DateTime createdAt;

  @HiveField(17)
  DateTime updatedAt;

  SimpleHiveBook({
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
    this.status = 'wantToRead',
    this.rating = 0.0,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Map for easy usage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publisher': publisher,
      'publishedYear': publishedYear,
      'isbn': isbn,
      'genre': genre,
      'description': description,
      'coverUrl': coverUrl,
      'coverLocalPath': coverLocalPath,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'status': status,
      'rating': rating,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Map
  factory SimpleHiveBook.fromMap(Map<String, dynamic> map) {
    return SimpleHiveBook(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      publisher: map['publisher'],
      publishedYear: map['publishedYear'],
      isbn: map['isbn'],
      genre: map['genre'],
      description: map['description'],
      coverUrl: map['coverUrl'],
      coverLocalPath: map['coverLocalPath'],
      totalPages: map['totalPages'] ?? 0,
      currentPage: map['currentPage'] ?? 0,
      status: map['status'] ?? 'wantToRead',
      rating: (map['rating'] ?? 0.0).toDouble(),
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Helper methods
  double get progress {
    if (totalPages <= 0) return 0.0;
    return (currentPage / totalPages).clamp(0.0, 1.0);
  }

  bool get isCompleted => status == 'read';
  bool get isReading => status == 'reading';
  bool get isWantToRead => status == 'wantToRead';

  SimpleHiveBook copyWith({
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
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SimpleHiveBook(
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
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
