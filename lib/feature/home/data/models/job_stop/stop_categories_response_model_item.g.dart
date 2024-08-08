// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_categories_response_model_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StopCategoriesResponseModelItemAdapter
    extends TypeAdapter<StopCategoriesResponseModelItem> {
  @override
  final int typeId = 103;

  @override
  StopCategoriesResponseModelItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StopCategoriesResponseModelItem(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StopCategoriesResponseModelItem obj) {
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
      other is StopCategoriesResponseModelItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
