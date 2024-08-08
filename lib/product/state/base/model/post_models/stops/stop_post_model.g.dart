// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StopPostModelAdapter extends TypeAdapter<StopPostModel> {
  @override
  final int typeId = 171;

  @override
  StopPostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StopPostModel(
      jobId: fields[0] as int,
      reason: fields[1] as String?,
      categoryId: fields[2] as int?,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      evidences: (fields[5] as List).cast<File>(),
    );
  }

  @override
  void write(BinaryWriter writer, StopPostModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.jobId)
      ..writeByte(1)
      ..write(obj.reason)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.evidences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopPostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
