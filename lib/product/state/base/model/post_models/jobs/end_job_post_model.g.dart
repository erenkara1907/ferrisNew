// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_job_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EndJobPostModelAdapter extends TypeAdapter<EndJobPostModel> {
  @override
  final int typeId = 102;

  @override
  EndJobPostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EndJobPostModel(
      endDate: fields[0] as int,
      spendCharging: fields[1] as String?,
      valetStandardId: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, EndJobPostModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.endDate)
      ..writeByte(1)
      ..write(obj.spendCharging)
      ..writeByte(2)
      ..write(obj.valetStandardId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EndJobPostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
