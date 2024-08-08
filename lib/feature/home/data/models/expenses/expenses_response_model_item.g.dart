// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_response_model_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpensesResponseModelItemAdapter
    extends TypeAdapter<ExpensesResponseModelItem> {
  @override
  final int typeId = 200;

  @override
  ExpensesResponseModelItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpensesResponseModelItem(
      id: fields[0] as int,
      jobId: fields[1] as int,
      categoryId: fields[2] as ExpenseCategoriesResponseModelItem?,
      price: fields[3] as double?,
      reasonNoReceipt: fields[4] as String,
      receiptPath: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExpensesResponseModelItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.reasonNoReceipt)
      ..writeByte(5)
      ..write(obj.receiptPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpensesResponseModelItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
