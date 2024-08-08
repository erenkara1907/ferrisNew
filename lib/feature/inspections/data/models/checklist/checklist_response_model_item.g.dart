// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_response_model_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChecklistResponseModelItemAdapter
    extends TypeAdapter<ChecklistResponseModelItem> {
  @override
  final int typeId = 161;

  @override
  ChecklistResponseModelItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChecklistResponseModelItem(
      id: fields[0] as int,
      jobInspectionId: fields[1] as int,
      inflatorKit: fields[2] as int,
      evCable: fields[3] as int,
      jack: fields[4] as int,
      spareWheel: fields[5] as int,
      gelCompressorKit: fields[6] as int,
      thirteenAmpEvChargingCable: fields[7] as int,
      hvChargingCable: fields[8] as int,
      spareKey: fields[9] as int,
      masterKey: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ChecklistResponseModelItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobInspectionId)
      ..writeByte(2)
      ..write(obj.inflatorKit)
      ..writeByte(3)
      ..write(obj.evCable)
      ..writeByte(4)
      ..write(obj.jack)
      ..writeByte(5)
      ..write(obj.spareWheel)
      ..writeByte(6)
      ..write(obj.gelCompressorKit)
      ..writeByte(7)
      ..write(obj.thirteenAmpEvChargingCable)
      ..writeByte(8)
      ..write(obj.hvChargingCable)
      ..writeByte(9)
      ..write(obj.spareKey)
      ..writeByte(10)
      ..write(obj.masterKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistResponseModelItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
