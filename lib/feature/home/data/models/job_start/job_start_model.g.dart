// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_start_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobStartModelAdapter extends TypeAdapter<JobStartModel> {
  @override
  final int typeId = 183;

  @override
  JobStartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobStartModel(
      id: fields[1] as int?,
      vehicleId: fields[2] as int?,
      combinationId: fields[3] as int?,
      price: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, JobStartModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.vehicleId)
      ..writeByte(3)
      ..write(obj.combinationId)
      ..writeByte(4)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobStartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
