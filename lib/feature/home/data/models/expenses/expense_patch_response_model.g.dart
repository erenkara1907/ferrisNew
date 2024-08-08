// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_patch_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpensePatchResponseModelAdapter
    extends TypeAdapter<ExpensePatchResponseModel> {
  @override
  final int typeId = 179;

  @override
  ExpensePatchResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpensePatchResponseModel(
      oldExpense: fields[0] as ExpensesResponseModelItem,
      newExpense: fields[1] as ExpensesResponseModelItem,
    );
  }

  @override
  void write(BinaryWriter writer, ExpensePatchResponseModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.oldExpense)
      ..writeByte(1)
      ..write(obj.newExpense);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpensePatchResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
