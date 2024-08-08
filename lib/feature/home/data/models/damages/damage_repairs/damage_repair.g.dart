// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_repair.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DamagesRepairAdapter extends TypeAdapter<DamagesRepair> {
  @override
  final int typeId = 159;

  @override
  DamagesRepair read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DamagesRepair(
      id: fields[0] as int,
      failureId: fields[1] as int,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DamagesRepair obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.failureId)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamagesRepairAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
