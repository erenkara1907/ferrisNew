// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 0;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense(
      id: fields[0] as String,
      jobId: fields[1] as int,
      categoryId: fields[2] as ExpenseCategoriesResponseModelItem?,
      price: fields[3] as double?,
      reasonNoReceipt: fields[4] as String,
      receiptPathsLocal: (fields[5] as List).cast<String>(),
      syncedExpense: fields[6] as ExpensesResponseModelItem?,
      synced: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.receiptPathsLocal)
      ..writeByte(6)
      ..write(obj.syncedExpense)
      ..writeByte(7)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
