// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventModelAdapter extends TypeAdapter<EventModel> {
  @override
  final int typeId = 21;

  @override
  EventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventModel(
      id: fields[0] as String,
      title: fields[1] as String,
      eventType: fields[2] as String,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
      venue: fields[5] as String,
      city: fields[6] as String,
      place: fields[7] as String,
      guest: fields[8] as String?,
      frequency: fields[9] as String?,
      day: fields[10] as String?,
      activities: (fields[11] as List?)?.cast<ActivityModel>(),
      description: fields[12] as String,
      interestedCount: fields[13] as int,
      galleryLinks: (fields[14] as List).cast<String>(),
      status: fields[15] as String,
      tags: (fields[19] as List?)?.cast<String>(),
      rsvp: fields[16] as bool,
      rsvpCount: fields[17] as int?,
      isFeatured: fields[18] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, EventModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.eventType)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.venue)
      ..writeByte(6)
      ..write(obj.city)
      ..writeByte(7)
      ..write(obj.place)
      ..writeByte(8)
      ..write(obj.guest)
      ..writeByte(9)
      ..write(obj.frequency)
      ..writeByte(10)
      ..write(obj.day)
      ..writeByte(11)
      ..write(obj.activities)
      ..writeByte(12)
      ..write(obj.description)
      ..writeByte(13)
      ..write(obj.interestedCount)
      ..writeByte(14)
      ..write(obj.galleryLinks)
      ..writeByte(15)
      ..write(obj.status)
      ..writeByte(16)
      ..write(obj.rsvp)
      ..writeByte(17)
      ..write(obj.rsvpCount)
      ..writeByte(18)
      ..write(obj.isFeatured)
      ..writeByte(19)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
