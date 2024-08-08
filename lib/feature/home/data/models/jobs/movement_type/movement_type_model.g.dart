// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_type_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovementTypeModelAdapter extends TypeAdapter<MovementTypeModel> {
  @override
  final int typeId = 106;

  @override
  MovementTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovementTypeModel(
      id: fields[0] as int,
      name: fields[1] as String,
      availableFuelEvLevelInputs: (fields[2] as List).cast<String>(),
      availableTimeInputs: (fields[3] as List).cast<String>(),
      availableTrackingStatuses:
          (fields[4] as List).cast<TrackingStatusModel>(),
      feedbackInputs: fields[5] as FeedbackInputAvailability?,
      isAvailableValetStandardInput: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, MovementTypeModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.availableFuelEvLevelInputs)
      ..writeByte(3)
      ..write(obj.availableTimeInputs)
      ..writeByte(4)
      ..write(obj.availableTrackingStatuses)
      ..writeByte(5)
      ..write(obj.feedbackInputs)
      ..writeByte(6)
      ..write(obj.isAvailableValetStandardInput);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovementTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
