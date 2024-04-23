import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_management/db/Category/category_db.dart';
import 'package:money_management/db/Transaction/transaction_db.dart';
import 'package:money_management/models/Category/category_model.dart';
import 'package:money_management/models/Transaction/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.interface.refreshTransaction();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.interface.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, _) {
        List<String> datesList = newList
            .map((transaction) => parsedDateHeaders(transaction.date))
            .toList();
        datesList = datesList.toSet().toList();
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          itemBuilder: (ctx, index) {
            return Column(
              children: [
                Text(
                  datesList[index],
                  style: const TextStyle(
                    color: Color.fromARGB(255, 120, 111, 166),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Wrap(
                  children: newList.map((e) {
                    List<TransactionModel> _filteredList = [];
                    for (final transaction in newList) {
                      var getMonth = parsedDateHeaders(transaction.date);
                      if (getMonth == datesList[index]) {
                        _filteredList.add(transaction);
                      }
                    }
                    int index2 = _filteredList.indexOf(e);
                    if (index2 >= 0 && index2 < _filteredList.length) {
                      return Container(
                        padding: EdgeInsets.all(10.h),
                        margin: EdgeInsets.all(5.h),
                        child: Slidable(
                          key: Key(_filteredList[index2].id!),
                          startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (ctx) {
                                  TransactionDB.interface.deleteTransaction(
                                      _filteredList[index2].id!);
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red.shade600,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _filteredList[index2].type ==
                                        CategoryType.income
                                    ? Colors.green[600]
                                    : Colors.red[600],
                                radius: 45.h,
                                child: Text(
                                  parsedDate(_filteredList[index2].date),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              title: Text(
                                  'Rs ${_filteredList[index2].amount.toInt()}'),
                              subtitle: Text(_filteredList[index2].purpose),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }).toList(),
                ),
              ],
            );
          },
          separatorBuilder: (ctx, index) {
            return SizedBox(height: 10.h);
          },
          itemCount: datesList.length,
        );
      },
    );
  }

  String parsedDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splittedDate = _date.split(' ');
    return '${_splittedDate.last}\n ${_splittedDate.first}';
  }

  String parsedDateHeaders(DateTime date) {
    return DateFormat.yMMMM().format(date);
  }
}
