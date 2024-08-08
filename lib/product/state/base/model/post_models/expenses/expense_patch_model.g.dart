part of 'expense_patch_model.dart';

class ExpensePatchModelAdapter extends TypeAdapter<ExpensePatchModel> {
  @override
  final int typeId = 222;

  @override
  ExpensePatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpensePatchModel(
      expenseId: fields[0] as int?,
      categoryId: fields[1] as int,
      price: fields[2] as double,
      reasonNoReceipt: fields[3] as String?,
      receipt: fields[4] as File?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpensePatchModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.expenseId)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.reasonNoReceipt)
      ..writeByte(4)
      ..write(obj.receipt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpensePatchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
