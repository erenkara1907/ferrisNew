// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_damage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspectionDamageAdapter extends TypeAdapter<InspectionDamage> {
  @override
  final int typeId = 153;

  @override
  InspectionDamage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InspectionDamage(
      id: fields[0] as String,
      inspectionId: fields[1] as int,
      category: fields[2] as DamagesCategory,
      part: fields[3] as DamagesPart,
      issue: fields[4] as DamagesIssue,
      failure: fields[5] as DamagesFailure,
      repair: fields[6] as DamagesRepair,
      damageImagePath: fields[7] as String,
      contextImagePath: fields[8] as String,
      synced: fields[9] as bool,
      patchDamageImage: fields[10] as bool,
      patchContextImage: fields[11] as bool,
      damageResponseModel: fields[12] as DamageResponseModel?,
    );
  }

  @override
  void write(BinaryWriter writer, InspectionDamage obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.inspectionId)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.part)
      ..writeByte(4)
      ..write(obj.issue)
      ..writeByte(5)
      ..write(obj.failure)
      ..writeByte(6)
      ..write(obj.repair)
      ..writeByte(7)
      ..write(obj.damageImagePath)
      ..writeByte(8)
      ..write(obj.contextImagePath)
      ..writeByte(9)
      ..write(obj.synced)
      ..writeByte(10)
      ..write(obj.patchDamageImage)
      ..writeByte(11)
      ..write(obj.patchContextImage)
      ..writeByte(12)
      ..write(obj.damageResponseModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionDamageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
