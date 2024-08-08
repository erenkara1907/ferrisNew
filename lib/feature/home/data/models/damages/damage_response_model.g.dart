// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DamageResponseModelAdapter extends TypeAdapter<DamageResponseModel> {
  @override
  final int typeId = 154;

  @override
  DamageResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DamageResponseModel(
      id: fields[0] as int,
      jobInspectionId: fields[1] as int,
      categoryId: fields[2] as DamagesCategory,
      partId: fields[3] as DamagesPart,
      issueId: fields[4] as DamagesIssue,
      failureId: fields[5] as DamagesFailure,
      repairId: fields[6] as DamagesRepair,
      damageImage: fields[7] as String?,
      contextImage: fields[8] as String?,
      price: fields[9] as double?,
      gradeId: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DamageResponseModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobInspectionId)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.partId)
      ..writeByte(4)
      ..write(obj.issueId)
      ..writeByte(5)
      ..write(obj.failureId)
      ..writeByte(6)
      ..write(obj.repairId)
      ..writeByte(7)
      ..write(obj.damageImage)
      ..writeByte(8)
      ..write(obj.contextImage)
      ..writeByte(9)
      ..write(obj.price)
      ..writeByte(10)
      ..write(obj.gradeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamageResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
