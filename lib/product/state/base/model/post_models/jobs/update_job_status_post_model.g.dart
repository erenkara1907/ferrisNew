// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_job_status_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UpdateJobStatusPostModelAdapter
    extends TypeAdapter<UpdateJobStatusPostModel> {
  @override
  final int typeId = 188;

  @override
  UpdateJobStatusPostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UpdateJobStatusPostModel(
      timestamp: fields[0] as String,
      fuelChargeLevelDelivery: fields[1] as int?,
      fuelChargeLevelCollection: fields[2] as int?,
      vehicleFeedback: fields[3] as String?,
      customerFeedback: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UpdateJobStatusPostModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.fuelChargeLevelDelivery)
      ..writeByte(2)
      ..write(obj.fuelChargeLevelCollection)
      ..writeByte(3)
      ..write(obj.vehicleFeedback)
      ..writeByte(4)
      ..write(obj.customerFeedback);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateJobStatusPostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
