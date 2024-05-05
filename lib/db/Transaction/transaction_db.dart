import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cash_flow/models/Transaction/transaction_model.dart';

const Transaction_DB_Name = 'transaction-db';

abstract class TransactionDBFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getTransaction();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDBFunctions {
  TransactionDB._internal();
  static TransactionDB interface = TransactionDB._internal();

  factory TransactionDB() {
    return interface;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(Transaction_DB_Name);
    _db.put(obj.id, obj);
  }

  @override
  Future<List<TransactionModel>> getTransaction() async {
    final _db = await Hive.openBox<TransactionModel>(Transaction_DB_Name);
    return _db.values.toList();
  }

  Future<void> refreshTransaction() async {
    final _list = await getTransaction();
    _list.sort((first, second) => second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(Transaction_DB_Name);
    _db.delete(id);
    refreshTransaction();
  }
}
