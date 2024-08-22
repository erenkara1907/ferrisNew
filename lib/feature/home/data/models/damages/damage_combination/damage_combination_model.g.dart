// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_combination_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DamageCombinationModelAdapter
    extends TypeAdapter<DamageCombinationModel> {
  @override
  final int typeId = 130;

  @override
  DamageCombinationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DamageCombinationModel(
      id: fields[1] as int?,
      categoryId: fields[2] as int?,
      partId: fields[3] as int?,
      issueId: fields[4] as int?,
      failureId: fields[5] as int?,
      repairId: fields[6] as int?,
      damageStandards: (fields[7] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, DamageCombinationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.id)
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
      ..write(obj.damageStandards);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamageCombinationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
