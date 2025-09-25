// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => NoteModel(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      title: json['title'] as String?,
      content: json['content'] as String,
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$NoteModelToJson(NoteModel instance) => <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'title': instance.title,
      'content': instance.content,
      'pageNumber': instance.pageNumber,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
