// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_damage_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspectionDamagePostModelAdapter
    extends TypeAdapter<InspectionDamagePostModel> {
  @override
  final int typeId = 193;

  @override
  InspectionDamagePostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InspectionDamagePostModel(
      jobInspectionId: fields[0] as int,
      categoryId: fields[1] as int,
      partId: fields[2] as int,
      issueId: fields[3] as int,
      failureId: fields[4] as int,
      repairId: fields[5] as int,
      damageId: fields[8] as int?,
      damageImage: fields[6] as File?,
      contextImage: fields[7] as File?,
    );
  }

  @override
  void write(BinaryWriter writer, InspectionDamagePostModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.jobInspectionId)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.partId)
      ..writeByte(3)
      ..write(obj.issueId)
      ..writeByte(4)
      ..write(obj.failureId)
      ..writeByte(5)
      ..write(obj.repairId)
      ..writeByte(6)
      ..write(obj.damageImage)
      ..writeByte(7)
      ..write(obj.contextImage)
      ..writeByte(8)
      ..write(obj.damageId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionDamagePostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
