// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DamagesCategoryAdapter extends TypeAdapter<DamagesCategory> {
  @override
  final int typeId = 155;

  @override
  DamagesCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DamagesCategory(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DamagesCategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamagesCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
