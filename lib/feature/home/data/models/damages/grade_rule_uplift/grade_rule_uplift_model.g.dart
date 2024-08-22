// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_rule_uplift_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GradeRuleUpliftModelAdapter extends TypeAdapter<GradeRuleUpliftModel> {
  @override
  final int typeId = 139;

  @override
  GradeRuleUpliftModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GradeRuleUpliftModel(
      gradeRuleId: fields[1] as int?,
      upToGradeId: fields[2] as int?,
      requiredDamageCombinationCount: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, GradeRuleUpliftModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.gradeRuleId)
      ..writeByte(2)
      ..write(obj.upToGradeId)
      ..writeByte(3)
      ..write(obj.requiredDamageCombinationCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeRuleUpliftModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
