// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspectionDetailsAdapter extends TypeAdapter<InspectionDetails> {
  @override
  final int typeId = 162;

  @override
  InspectionDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InspectionDetails(
      inspectionId: fields[0] as int,
      odoReadingInMiles: fields[1] as double,
      fuelLevel: fields[2] as int,
      synced: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, InspectionDetails obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.inspectionId)
      ..writeByte(1)
      ..write(obj.odoReadingInMiles)
      ..writeByte(2)
      ..write(obj.fuelLevel)
      ..writeByte(3)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
