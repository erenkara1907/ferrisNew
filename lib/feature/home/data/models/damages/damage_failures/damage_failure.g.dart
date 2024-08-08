// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_failure.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DamagesFailureAdapter extends TypeAdapter<DamagesFailure> {
  @override
  final int typeId = 158;

  @override
  DamagesFailure read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DamagesFailure(
      id: fields[0] as int,
      issueId: fields[1] as int,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DamagesFailure obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.issueId)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamagesFailureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
