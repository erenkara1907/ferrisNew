// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_image_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConditionImageResponseModelAdapter
    extends TypeAdapter<ConditionImageResponseModel> {
  @override
  final int typeId = 164;

  @override
  ConditionImageResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConditionImageResponseModel(
      id: fields[0] as int,
      jobInspectionId: fields[1] as int,
      imagePath: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ConditionImageResponseModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobInspectionId)
      ..writeByte(2)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConditionImageResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
