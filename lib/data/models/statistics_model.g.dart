// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatisticsModel _$StatisticsModelFromJson(Map<String, dynamic> json) =>
    StatisticsModel(
      totalBooks: (json['totalBooks'] as num).toInt(),
      booksRead: (json['booksRead'] as num).toInt(),
      booksReading: (json['booksReading'] as num).toInt(),
      booksWantToRead: (json['booksWantToRead'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      pagesRead: (json['pagesRead'] as num).toInt(),
      averageRating: (json['averageRating'] as num).toDouble(),
      booksThisYear: (json['booksThisYear'] as num).toInt(),
      booksThisMonth: (json['booksThisMonth'] as num).toInt(),
      favoriteGenre: json['favoriteGenre'] as String?,
      averageReadingDays: (json['averageReadingDays'] as num).toDouble(),
      genreDistribution: Map<String, int>.from(
        json['genreDistribution'] as Map,
      ),
      monthlyReading: Map<String, int>.from(json['monthlyReading'] as Map),
      ratingDistribution: (json['ratingDistribution'] as Map<String, dynamic>)
          .map((k, e) => MapEntry(k, (e as num).toDouble())),
      calculatedAt: json['calculatedAt'] as String,
    );

Map<String, dynamic> _$StatisticsModelToJson(StatisticsModel instance) =>
    <String, dynamic>{
      'totalBooks': instance.totalBooks,
      'booksRead': instance.booksRead,
      'booksReading': instance.booksReading,
      'booksWantToRead': instance.booksWantToRead,
      'totalPages': instance.totalPages,
      'pagesRead': instance.pagesRead,
      'averageRating': instance.averageRating,
      'booksThisYear': instance.booksThisYear,
      'booksThisMonth': instance.booksThisMonth,
      'favoriteGenre': instance.favoriteGenre,
      'averageReadingDays': instance.averageReadingDays,
      'genreDistribution': instance.genreDistribution,
      'monthlyReading': instance.monthlyReading,
      'ratingDistribution': instance.ratingDistribution,
      'calculatedAt': instance.calculatedAt,
    };
