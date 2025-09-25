// 📚 FolhaVirada - Hive Note Model
// Modelo de dados para notas/anotações com Hive

import 'package:hive/hive.dart';
import 'package:folhavirada/domain/entities/note_entity.dart';

part 'hive_note_model.g.dart';

@HiveType(typeId: 1)
class HiveNoteModel extends HiveObject {
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
  DateTime? updatedAt;

  @HiveField(7)
  String? quote;

  @HiveField(8)
  String? type; // 'note', 'highlight', 'quote', 'reflection'

  @HiveField(9)
  String? color; // For color-coded notes

  @HiveField(10)
  List<String>? tags;

  HiveNoteModel({
    required this.id,
    required this.bookId,
    this.title,
    required this.content,
    this.pageNumber,
    required this.createdAt,
    this.updatedAt,
    this.quote,
    this.type = 'note',
    this.color,
    this.tags,
  });

  // Convert to domain entity
  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      bookId: bookId,
      title: title,
      content: content,
      pageNumber: pageNumber,
      createdAt: createdAt,
      updatedAt: updatedAt,
      quote: quote,
      type: type,
      color: color,
      tags: tags,
    );
  }

  // Create from domain entity
  factory HiveNoteModel.fromEntity(NoteEntity entity) {
    return HiveNoteModel(
      id: entity.id,
      bookId: entity.bookId,
      title: entity.title,
      content: entity.content,
      pageNumber: entity.pageNumber,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      quote: entity.quote,
      type: entity.type,
      color: entity.color,
      tags: entity.tags,
    );
  }

  // Copy with method
  HiveNoteModel copyWith({
    String? id,
    String? bookId,
    String? title,
    String? content,
    int? pageNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? quote,
    String? type,
    String? color,
    List<String>? tags,
  }) {
    return HiveNoteModel(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      content: content ?? this.content,
      pageNumber: pageNumber ?? this.pageNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      quote: quote ?? this.quote,
      type: type ?? this.type,
      color: color ?? this.color,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() {
    return 'HiveNoteModel(id: $id, bookId: $bookId, title: $title)';
  }
}
