// File: transaction_model.g.dart
// Generated code - Do not modify by hand

part of 'transaction_model.dart';

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 0;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = Map<int, dynamic>.fromIterables(
      List.generate(numOfFields, (index) => reader.readByte()),
      List.generate(numOfFields, (index) => reader.read()),
    );

    return TransactionModel(
      isExpense: fields[0] as bool,
      category: fields[1] as String,
      amount: fields[2] as int,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.isExpense)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date);
  }
}
