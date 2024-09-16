// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_combination_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DamageCombinationModelAdapter extends TypeAdapter<DamageCombinationModel> {
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
      categoryId: fields[2] as CategoryId?,
      partId: fields[3] as PartId?,
      issueId: fields[4] as IssueId?,
      failureId: fields[5] as FailureId?,
      repairId: fields[6] as RepairId?,
      damageStandards: (fields[7] as List?)?.cast<int>(),
      score: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DamageCombinationModel obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.damageStandards)
      ..writeByte(8)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamageCombinationModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class CategoryIdAdapter extends TypeAdapter<CategoryId> {
  @override
  final int typeId = 131;

  @override
  CategoryId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryId(
      id: fields[1] as int?,
      name: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryId obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryIdAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class FailureIdAdapter extends TypeAdapter<FailureId> {
  @override
  final int typeId = 138;

  @override
  FailureId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FailureId(
      id: fields[1] as int?,
      issueId: fields[2] as int?,
      name: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FailureId obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.issueId)
      ..writeByte(3)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FailureIdAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class IssueIdAdapter extends TypeAdapter<IssueId> {
  @override
  final int typeId = 140;

  @override
  IssueId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IssueId(
      id: fields[1] as int?,
      partId: fields[2] as int?,
      name: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IssueId obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.partId)
      ..writeByte(3)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is IssueIdAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class PartIdAdapter extends TypeAdapter<PartId> {
  @override
  final int typeId = 141;

  @override
  PartId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartId(
      id: fields[1] as int?,
      categoryId: fields[2] as int?,
      name: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PartId obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PartIdAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class RepairIdAdapter extends TypeAdapter<RepairId> {
  @override
  final int typeId = 142;

  @override
  RepairId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepairId(
      id: fields[1] as int?,
      failureId: fields[2] as int?,
      name: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RepairId obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.failureId)
      ..writeByte(3)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RepairIdAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
