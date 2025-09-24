// 📚 FolhaVirada - Note Model
// Modelo de dados para notas

import 'package:json_annotation/json_annotation.dart';
import 'package:folhavirada/domain/entities/note_entity.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel {
  final String id;
  final String bookId;
  final String? title;
  final String content;
  final int? pageNumber;
  final String createdAt;
  final String updatedAt;

  const NoteModel({
    required this.id,
    required this.bookId,
    this.title,
    required this.content,
    this.pageNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor para JSON
  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  /// Converter para JSON
  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  /// Factory constructor para banco de dados
  factory NoteModel.fromDatabase(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      bookId: map['book_id'] as String,
      title: map['title'] as String?,
      content: map['content'] as String,
      pageNumber: map['page_number'] as int?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  /// Converter para mapa do banco de dados
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'book_id': bookId,
      'title': title,
      'content': content,
      'page_number': pageNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Converter para entidade do domínio
  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      bookId: bookId,
      title: title,
      content: content,
      pageNumber: pageNumber,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  /// Factory constructor da entidade do domínio
  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      bookId: entity.bookId,
      title: entity.title,
      content: entity.content,
      pageNumber: entity.pageNumber,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }

  /// Criar cópia com alterações
  NoteModel copyWith({
    String? id,
    String? bookId,
    String? title,
    String? content,
    int? pageNumber,
    String? createdAt,
    String? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      content: content ?? this.content,
      pageNumber: pageNumber ?? this.pageNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Métodos auxiliares

  /// Verificar se tem título
  bool get hasTitle => title != null && title!.trim().isNotEmpty;

  /// Verificar se está associada a uma página
  bool get hasPageNumber => pageNumber != null && pageNumber! > 0;

  /// Obter título efetivo (usa primeiras palavras do conteúdo se não tiver título)
  String get effectiveTitle {
    if (hasTitle) return title!;
    
    final words = content.trim().split(' ');
    if (words.length <= 5) return content.trim();
    
    return '${words.take(5).join(' ')}...';
  }

  /// Verificar se é uma nota longa
  bool get isLongNote => content.length > 200;

  /// Obter preview do conteúdo
  String getContentPreview([int maxLength = 100]) {
    if (content.length <= maxLength) return content;
    return '${content.substring(0, maxLength)}...';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'NoteModel{id: $id, bookId: $bookId, title: $title, hasContent: ${content.isNotEmpty}}';
  }
}
