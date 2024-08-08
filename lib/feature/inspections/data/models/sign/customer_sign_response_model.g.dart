// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_sign_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerSignResponseModelAdapter
    extends TypeAdapter<CustomerSignResponseModel> {
  @override
  final int typeId = 151;

  @override
  CustomerSignResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerSignResponseModel(
      customerSignatureImg: fields[0] as String,
      customerSignerName: fields[1] as String,
      customerSignLatitude: fields[2] as String,
      customerSignLongitude: fields[3] as String,
      date: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerSignResponseModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.customerSignatureImg)
      ..writeByte(1)
      ..write(obj.customerSignerName)
      ..writeByte(2)
      ..write(obj.customerSignLatitude)
      ..writeByte(3)
      ..write(obj.customerSignLongitude)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerSignResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
