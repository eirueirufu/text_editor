// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      name: fields[0] as String,
      updatedAt: fields[1] as DateTime,
    )..state = fields[2] == null ? [] : (fields[2] as List).cast<int>();
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.updatedAt)
      ..writeByte(2)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
