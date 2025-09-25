// 📚 FolhaVirada - Simple Hive Note Model
// Modelo simplificado para notas com Hive

import 'package:hive/hive.dart';

part 'simple_hive_note.g.dart';

@HiveType(typeId: 1)
class SimpleHiveNote extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String bookId;

  @HiveField(2)
  String? title;

  @HiveField(3)
  String content;

  @HiveField(4)
  int? pageNumber;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  SimpleHiveNote({
    required this.id,
    required this.bookId,
    this.title,
    required this.content,
    this.pageNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'title': title,
      'content': content,
      'pageNumber': pageNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Map
  factory SimpleHiveNote.fromMap(Map<String, dynamic> map) {
    return SimpleHiveNote(
      id: map['id'] ?? '',
      bookId: map['bookId'] ?? '',
      title: map['title'],
      content: map['content'] ?? '',
      pageNumber: map['pageNumber'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  SimpleHiveNote copyWith({
    String? id,
    String? bookId,
    String? title,
    String? content,
    int? pageNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SimpleHiveNote(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      content: content ?? this.content,
      pageNumber: pageNumber ?? this.pageNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
