// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_issue.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DamagesIssueAdapter extends TypeAdapter<DamagesIssue> {
  @override
  final int typeId = 157;

  @override
  DamagesIssue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DamagesIssue(
      id: fields[0] as int,
      partId: fields[1] as int,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DamagesIssue obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.partId)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamagesIssueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
