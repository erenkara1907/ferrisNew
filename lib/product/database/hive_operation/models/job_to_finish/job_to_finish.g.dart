// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_to_finish.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobToFinishAdapter extends TypeAdapter<JobToFinish> {
  @override
  final int typeId = 3;

  @override
  JobToFinish read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobToFinish(
      id: fields[0] as String,
      jobJson: fields[1] as String,
      endJobPostModel: fields[2] as EndJobPostModel,
    );
  }

  @override
  void write(BinaryWriter writer, JobToFinish obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobJson)
      ..writeByte(2)
      ..write(obj.endJobPostModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobToFinishAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
