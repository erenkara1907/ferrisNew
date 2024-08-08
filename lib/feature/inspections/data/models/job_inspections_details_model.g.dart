// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_inspections_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspectionDetailsPostModelAdapter
    extends TypeAdapter<InspectionDetailsPostModel> {
  @override
  final int typeId = 211;

  @override
  InspectionDetailsPostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InspectionDetailsPostModel(
      odoReading: fields[0] as double,
      fuelLevel: fields[1] as int,
      inspectionId: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, InspectionDetailsPostModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.odoReading)
      ..writeByte(1)
      ..write(obj.fuelLevel)
      ..writeByte(2)
      ..write(obj.inspectionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionDetailsPostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
