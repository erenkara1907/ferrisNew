// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_checklist_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspectionChecklistPostModelAdapter extends TypeAdapter<InspectionChecklistPostModel> {
  @override
  final int typeId = 191;

  @override
  InspectionChecklistPostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InspectionChecklistPostModel(
      jobInspectionId: fields[0] as int,
      inflatorKit: fields[1] as int,
      evCable: fields[2] as int,
      jack: fields[3] as int,
      spareWheel: fields[4] as int,
      gelCompressorKit: fields[5] as int,
      thirteenAmpEvChargingCable: fields[6] as int,
      hvChargingCable: fields[7] as int,
      spareKey: fields[8] as int,
      masterKey: fields[9] as int,
      id: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, InspectionChecklistPostModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.jobInspectionId)
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
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionChecklistPostModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
