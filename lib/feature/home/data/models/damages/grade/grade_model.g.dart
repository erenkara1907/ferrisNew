// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GradeModelAdapter extends TypeAdapter<GradeModel> {
  @override
  final int typeId = 132;

  @override
  GradeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GradeModel(
      id: fields[1] as int?,
      subClientId: fields[2] as SubClientId?,
      name: fields[3] as String?,
      order: fields[4] as int?,
      gradeId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GradeModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.subClientId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.order)
      ..writeByte(5)
      ..write(obj.gradeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubClientIdAdapter extends TypeAdapter<SubClientId> {
  @override
  final int typeId = 134;

  @override
  SubClientId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubClientId(
      id: fields[1] as int?,
      mainClientId: fields[2] as GradeMainClientId?,
      name: fields[3] as String?,
      address1: fields[4] as String?,
      postalCode: fields[5] as String?,
      locality: fields[6] as String?,
      country: fields[7] as String?,
      contactEmail: fields[8] as String?,
      contactNumber: fields[9] as String?,
      viewCosts: fields[10] as int?,
      limitedView: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SubClientId obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.mainClientId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.address1)
      ..writeByte(5)
      ..write(obj.postalCode)
      ..writeByte(6)
      ..write(obj.locality)
      ..writeByte(7)
      ..write(obj.country)
      ..writeByte(8)
      ..write(obj.contactEmail)
      ..writeByte(9)
      ..write(obj.contactNumber)
      ..writeByte(10)
      ..write(obj.viewCosts)
      ..writeByte(11)
      ..write(obj.limitedView);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubClientIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GradeMainClientIdAdapter extends TypeAdapter<GradeMainClientId> {
  @override
  final int typeId = 135;

  @override
  GradeMainClientId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GradeMainClientId(
      id: fields[1] as int?,
      name: fields[2] as String?,
      address1: fields[3] as String?,
      postalCode: fields[4] as String?,
      locality: fields[5] as dynamic,
      country: fields[6] as dynamic,
      contactEmail: fields[7] as String?,
      contactNumber: fields[8] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, GradeMainClientId obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.address1)
      ..writeByte(4)
      ..write(obj.postalCode)
      ..writeByte(5)
      ..write(obj.locality)
      ..writeByte(6)
      ..write(obj.country)
      ..writeByte(7)
      ..write(obj.contactEmail)
      ..writeByte(8)
      ..write(obj.contactNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeMainClientIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
