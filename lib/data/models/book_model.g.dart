// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
  id: json['id'] as String,
  title: json['title'] as String,
  author: json['author'] as String,
  publisher: json['publisher'] as String?,
  publishedYear: (json['publishedYear'] as num?)?.toInt(),
  isbn: json['isbn'] as String?,
  genre: json['genre'] as String?,
  description: json['description'] as String?,
  coverUrl: json['coverUrl'] as String?,
  coverLocalPath: json['coverLocalPath'] as String?,
  totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
  currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
  status: json['status'] as String? ?? 'want_to_read',
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'author': instance.author,
  'publisher': instance.publisher,
  'publishedYear': instance.publishedYear,
  'isbn': instance.isbn,
  'genre': instance.genre,
  'description': instance.description,
  'coverUrl': instance.coverUrl,
  'coverLocalPath': instance.coverLocalPath,
  'totalPages': instance.totalPages,
  'currentPage': instance.currentPage,
  'status': instance.status,
  'rating': instance.rating,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
