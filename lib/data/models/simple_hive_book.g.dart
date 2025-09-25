// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_hive_book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SimpleHiveBookAdapter extends TypeAdapter<SimpleHiveBook> {
  @override
  final int typeId = 0;

  @override
  SimpleHiveBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SimpleHiveBook(
      id: fields[0] as String,
      title: fields[1] as String,
      author: fields[2] as String,
      publisher: fields[3] as String?,
      publishedYear: fields[4] as int?,
      isbn: fields[5] as String?,
      genre: fields[6] as String?,
      description: fields[7] as String?,
      coverUrl: fields[8] as String?,
      coverLocalPath: fields[9] as String?,
      totalPages: fields[10] as int,
      currentPage: fields[11] as int,
      status: fields[12] as String,
      rating: fields[13] as double,
      startDate: fields[14] as DateTime?,
      endDate: fields[15] as DateTime?,
      createdAt: fields[16] as DateTime,
      updatedAt: fields[17] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SimpleHiveBook obj) {
    writer
      ..writeByte(18)
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
      ..write(obj.genre)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.coverUrl)
      ..writeByte(9)
      ..write(obj.coverLocalPath)
      ..writeByte(10)
      ..write(obj.totalPages)
      ..writeByte(11)
      ..write(obj.currentPage)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.rating)
      ..writeByte(14)
      ..write(obj.startDate)
      ..writeByte(15)
      ..write(obj.endDate)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleHiveBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
