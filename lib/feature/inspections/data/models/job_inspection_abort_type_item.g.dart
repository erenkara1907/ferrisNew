// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_inspection_abort_type_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobInspectionAbortTypeItemAdapter
    extends TypeAdapter<JobInspectionAbortTypeItem> {
  @override
  final int typeId = 199;

  @override
  JobInspectionAbortTypeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobInspectionAbortTypeItem(
      id: fields[0] as int,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, JobInspectionAbortTypeItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobInspectionAbortTypeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
