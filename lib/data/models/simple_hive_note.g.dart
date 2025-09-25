// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_hive_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SimpleHiveNoteAdapter extends TypeAdapter<SimpleHiveNote> {
  @override
  final int typeId = 1;

  @override
  SimpleHiveNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SimpleHiveNote(
      id: fields[0] as String,
      bookId: fields[1] as String,
      title: fields[2] as String?,
      content: fields[3] as String,
      pageNumber: fields[4] as int?,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SimpleHiveNote obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleHiveNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
