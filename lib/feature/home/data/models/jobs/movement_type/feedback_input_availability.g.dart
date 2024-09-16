// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_input_availability.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedbackInputAvailabilityAdapter extends TypeAdapter<FeedbackInputAvailability> {
  @override
  final int typeId = 109;

  @override
  FeedbackInputAvailability read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeedbackInputAvailability(
      vehicle: fields[0] as FeedbackInputAvailabilityEnum,
      customer: fields[1] as FeedbackInputAvailabilityEnum,
    );
  }

  @override
  void write(BinaryWriter writer, FeedbackInputAvailability obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.vehicle)
      ..writeByte(1)
      ..write(obj.customer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackInputAvailabilityAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class FeedbackInputAvailabilityEnumAdapter extends TypeAdapter<FeedbackInputAvailabilityEnum> {
  @override
  final int typeId = 110;

  @override
  FeedbackInputAvailabilityEnum read(BinaryReader reader) {
    final index = reader.readByte();
    return FeedbackInputAvailabilityEnum.values[index];
  }

  @override
  void write(BinaryWriter writer, FeedbackInputAvailabilityEnum obj) {
    writer.writeByte(obj.index);
  }
}
