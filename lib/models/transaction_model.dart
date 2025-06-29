import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late bool isExpense;

  @HiveField(1)
  late String category;

  @HiveField(2)
  late int amount;

  @HiveField(3)
  late DateTime date;

  TransactionModel({
    required this.isExpense,
    required this.category,
    required this.amount,
    required this.date,
  });
}
