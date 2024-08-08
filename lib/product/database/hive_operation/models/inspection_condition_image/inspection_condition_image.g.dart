// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_condition_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspectionConditionImageAdapter
    extends TypeAdapter<InspectionConditionImage> {
  @override
  final int typeId = 163;

  @override
  InspectionConditionImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InspectionConditionImage(
      id: fields[0] as String,
      inspectionId: fields[1] as int,
      image: fields[3] as String?,
      conditionImageResponseModel: fields[4] as ConditionImageResponseModel?,
      markedForDeletion: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, InspectionConditionImage obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.inspectionId)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.conditionImageResponseModel)
      ..writeByte(5)
      ..write(obj.markedForDeletion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionConditionImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
