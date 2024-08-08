// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_update.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobUpdateAdapter extends TypeAdapter<JobUpdate> {
  @override
  final int typeId = 2;

  @override
  JobUpdate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobUpdate(
      uuid: fields[0] as String,
      jobId: fields[1] as int,
      isSynced: fields[2] as bool,
      timestamp: fields[3] as int,
      trackingStatusId: fields[4] as int?,
      fuelChargeLevelDelivery: fields[5] as int?,
      fuelChargeLevelCollection: fields[6] as int?,
      vehicleFeedback: fields[7] as String?,
      customerFeedback: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, JobUpdate obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.isSynced)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.trackingStatusId)
      ..writeByte(5)
      ..write(obj.fuelChargeLevelDelivery)
      ..writeByte(6)
      ..write(obj.fuelChargeLevelCollection)
      ..writeByte(7)
      ..write(obj.vehicleFeedback)
      ..writeByte(8)
      ..write(obj.customerFeedback);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobUpdateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
