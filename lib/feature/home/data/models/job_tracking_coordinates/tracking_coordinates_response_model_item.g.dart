// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_coordinates_response_model_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackingCoordinatesResponseModelItemAdapter
    extends TypeAdapter<TrackingCoordinatesResponseModelItem> {
  @override
  final int typeId = 129;

  @override
  TrackingCoordinatesResponseModelItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackingCoordinatesResponseModelItem(
      id: fields[0] as int?,
      jobId: fields[1] as int?,
      addedTime: fields[2] as int?,
      latitude: fields[3] as double?,
      longitude: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, TrackingCoordinatesResponseModelItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.addedTime)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackingCoordinatesResponseModelItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
