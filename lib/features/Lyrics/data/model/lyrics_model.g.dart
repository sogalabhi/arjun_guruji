// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LyricsModelAdapter extends TypeAdapter<LyricsModel> {
  @override
  final int typeId = 3;

  @override
  LyricsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LyricsModel(
      docId: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      content: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LyricsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.docId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
