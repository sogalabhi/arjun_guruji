// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AstottaraModelAdapter extends TypeAdapter<AstottaraModel> {
  @override
  final int typeId = 1;

  @override
  AstottaraModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AstottaraModel(
      title: fields[0] as String,
      imageUrl: fields[1] as String,
      content: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AstottaraModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstottaraModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
