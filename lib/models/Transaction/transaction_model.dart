import 'package:hive_flutter/hive_flutter.dart';
import 'package:cash_flow/models/Category/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String purpose;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final CategoryType type;
  @HiveField(5)
  final CategoryModel categoryModel;

  TransactionModel(
      {required this.purpose,
      required this.amount,
      required this.date,
      required this.type,
      required this.categoryModel}) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }
}
