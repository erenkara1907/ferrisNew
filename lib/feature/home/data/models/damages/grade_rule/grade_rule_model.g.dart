// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_rule_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GradeRuleModelAdapter extends TypeAdapter<GradeRuleModel> {
  @override
  final int typeId = 136;

  @override
  GradeRuleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GradeRuleModel(
      id: fields[0] as int?,
      gradeId: fields[1] as int?,
      requiredDamageCombinationId: fields[2] as int?,
      requiredDamageCombinationCount: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, GradeRuleModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.gradeId)
      ..writeByte(2)
      ..write(obj.requiredDamageCombinationId)
      ..writeByte(3)
      ..write(obj.requiredDamageCombinationCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeRuleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
