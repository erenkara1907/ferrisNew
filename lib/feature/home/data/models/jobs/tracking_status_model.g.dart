// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_status_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackingStatusModelAdapter extends TypeAdapter<TrackingStatusModel> {
  @override
  final int typeId = 115;

  @override
  TrackingStatusModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackingStatusModel(
      id: fields[0] as int,
      name: fields[1] as String,
      isTrackable: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TrackingStatusModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isTrackable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackingStatusModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
