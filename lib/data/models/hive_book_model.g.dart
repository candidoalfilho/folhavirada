// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveBookModelAdapter extends TypeAdapter<HiveBookModel> {
  @override
  final int typeId = 0;

  @override
  HiveBookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveBookModel(
      id: fields[0] as String,
      title: fields[1] as String,
      author: fields[2] as String,
      publisher: fields[3] as String?,
      publishedYear: fields[4] as int?,
      isbn: fields[5] as String?,
      totalPages: fields[6] as int?,
      currentPage: fields[7] as int?,
      genre: fields[8] as String?,
      description: fields[9] as String?,
      status: fields[10] as String,
      rating: fields[11] as double?,
      startDate: fields[12] as DateTime?,
      endDate: fields[13] as DateTime?,
      coverLocalPath: fields[14] as String?,
      coverUrl: fields[15] as String?,
      createdAt: fields[16] as DateTime,
      updatedAt: fields[17] as DateTime,
      isFavorite: fields[18] as bool,
      tags: (fields[19] as List?)?.cast<String>(),
      language: fields[20] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveBookModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.publisher)
      ..writeByte(4)
      ..write(obj.publishedYear)
      ..writeByte(5)
      ..write(obj.isbn)
      ..writeByte(6)
      ..write(obj.totalPages)
      ..writeByte(7)
      ..write(obj.currentPage)
      ..writeByte(8)
      ..write(obj.genre)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.rating)
      ..writeByte(12)
      ..write(obj.startDate)
      ..writeByte(13)
      ..write(obj.endDate)
      ..writeByte(14)
      ..write(obj.coverLocalPath)
      ..writeByte(15)
      ..write(obj.coverUrl)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt)
      ..writeByte(18)
      ..write(obj.isFavorite)
      ..writeByte(19)
      ..write(obj.tags)
      ..writeByte(20)
      ..write(obj.language);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveBookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
