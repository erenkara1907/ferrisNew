// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_evidence_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StopEvidenceModelAdapter extends TypeAdapter<StopEvidenceModel> {
  @override
  final int typeId = 101;

  @override
  StopEvidenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StopEvidenceModel(
      id: fields[0] as int,
      jobStopId: fields[1] as int,
      path: fields[2] as String,
      addedBy: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, StopEvidenceModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobStopId)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.addedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopEvidenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
