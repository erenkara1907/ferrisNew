// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_inspector_sign_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspectionInspectorSignPostModelAdapter
    extends TypeAdapter<InspectionInspectorSignPostModel> {
  @override
  final int typeId = 196;

  @override
  InspectionInspectorSignPostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InspectionInspectorSignPostModel(
      inspectorSignatureImg: fields[0] as File,
      inspectorSignerName: fields[1] as String,
      inspectorSignLatitude: fields[2] as String,
      inspectorSignLongitude: fields[3] as String,
      date: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InspectionInspectorSignPostModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.inspectorSignatureImg)
      ..writeByte(1)
      ..write(obj.inspectorSignerName)
      ..writeByte(2)
      ..write(obj.inspectorSignLatitude)
      ..writeByte(3)
      ..write(obj.inspectorSignLongitude)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionInspectorSignPostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
