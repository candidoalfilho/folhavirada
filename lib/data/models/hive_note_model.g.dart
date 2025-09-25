// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_note_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveNoteModelAdapter extends TypeAdapter<HiveNoteModel> {
  @override
  final int typeId = 1;

  @override
  HiveNoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveNoteModel(
      id: fields[0] as String,
      bookId: fields[1] as String,
      title: fields[2] as String?,
      content: fields[3] as String,
      pageNumber: fields[4] as int?,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime?,
      quote: fields[7] as String?,
      type: fields[8] as String?,
      color: fields[9] as String?,
      tags: (fields[10] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveNoteModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.pageNumber)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.quote)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.color)
      ..writeByte(10)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveNoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
