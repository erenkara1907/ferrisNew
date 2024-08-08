// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_checklist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspectionChecklistAdapter extends TypeAdapter<InspectionChecklist> {
  @override
  final int typeId = 160;

  @override
  InspectionChecklist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InspectionChecklist(
      inspectionId: fields[0] as int,
      inflatorKit: fields[1] as int,
      evCable: fields[2] as int,
      jack: fields[3] as int,
      spareWheel: fields[4] as int,
      gelCompressorKit: fields[5] as int,
      thirteenAmpEvChargingCable: fields[6] as int,
      hvChargingCable: fields[7] as int,
      spareKey: fields[8] as int,
      masterKey: fields[9] as int,
      synced: fields[10] as bool,
      responseModel: fields[11] as ChecklistResponseModelItem?,
    );
  }

  @override
  void write(BinaryWriter writer, InspectionChecklist obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.inspectionId)
      ..writeByte(1)
      ..write(obj.inflatorKit)
      ..writeByte(2)
      ..write(obj.evCable)
      ..writeByte(3)
      ..write(obj.jack)
      ..writeByte(4)
      ..write(obj.spareWheel)
      ..writeByte(5)
      ..write(obj.gelCompressorKit)
      ..writeByte(6)
      ..write(obj.thirteenAmpEvChargingCable)
      ..writeByte(7)
      ..write(obj.hvChargingCable)
      ..writeByte(8)
      ..write(obj.spareKey)
      ..writeByte(9)
      ..write(obj.masterKey)
      ..writeByte(10)
      ..write(obj.synced)
      ..writeByte(11)
      ..write(obj.responseModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionChecklistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
