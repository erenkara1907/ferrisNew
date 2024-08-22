// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stops_response_model_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StopsResponseModelItemAdapter
    extends TypeAdapter<StopsResponseModelItem> {
  @override
  final int typeId = 201;

  @override
  StopsResponseModelItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StopsResponseModelItem(
      id: fields[0] as int?,
      jobId: fields[1] as int?,
      reason: fields[2] as String?,
      longitude: fields[3] as double?,
      latitude: fields[4] as double?,
      evidence: fields[6] as String?,
      categoryId: fields[7] as StopCategoriesResponseModelItem?,
    );
  }

  @override
  void write(BinaryWriter writer, StopsResponseModelItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.reason)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(6)
      ..write(obj.evidence)
      ..writeByte(7)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopsResponseModelItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
