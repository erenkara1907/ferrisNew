// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_condition_image_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspectionConditionImagePostModelAdapter
    extends TypeAdapter<InspectionConditionImagePostModel> {
  @override
  final int typeId = 192;

  @override
  InspectionConditionImagePostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InspectionConditionImagePostModel(
      jobInspectionId: fields[0] as int?,
      image: fields[1] as File,
    );
  }

  @override
  void write(BinaryWriter writer, InspectionConditionImagePostModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.jobInspectionId)
      ..writeByte(1)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionConditionImagePostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
