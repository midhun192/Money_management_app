import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cash_flow/db/Category/category_db.dart';
import 'package:cash_flow/db/Transaction/transaction_db.dart';
import 'package:cash_flow/models/Category/category_model.dart';
import 'package:cash_flow/models/Transaction/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenAddTransaction({super.key});

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategory1;
  CategoryModel? _SelectedCategoryModel;

  String? _categoryID;

  final _purposeEditingController = TextEditingController();
  final _amountEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _selectedCategory1 = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20.h),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Purpose is Required';
                  } else {
                    return null;
                  }
                },
                controller: _purposeEditingController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Purpose',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount is Required';
                  } else {
                    return null;
                  }
                },
                controller: _amountEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Amount',
                ),
              ),
              SizedBox(height: 20.h),
              TextButton.icon(
                onPressed: () async {
                  final _selectedDateTemp = await showDatePicker(
                    context: context,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    setState(() {
                      _selectedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(_selectedDate == null
                    ? 'Select Date'
                    : _selectedDate!.toString()),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategory1,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategory1 = CategoryType.income;
                            _categoryID = null;
                          });
                        },
                      ),
                      const Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedCategory1,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategory1 = CategoryType.expense;
                            _categoryID = null;
                          });
                        },
                      ),
                      const Text('Expense'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              DropdownButton<String>(
                value: _categoryID,
                hint: const Text('Select Category'),
                items: (_selectedCategory1 == CategoryType.income
                        ? CategoryDB().incomeCategorListNotifier.value
                        : CategoryDB().expenseCategoryListNotifier.value)
                    .map((e) {
                  return DropdownMenuItem(
                    onTap: () {
                      _SelectedCategoryModel = e;
                    },
                    value: e.id,
                    child: Text(e.name),
                  );
                }).toList(),
                onChanged: (newSelectedValue) {
                  setState(() {
                    _categoryID = newSelectedValue;
                  });
                },
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.validate();
                  addtransaction();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> addtransaction() async {
    final _purposeText = _purposeEditingController.text;
    final _amountText = _amountEditingController.text;

    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }

    if (_selectedDate == null) {
      return;
    }

    final _parsedAmount = double.tryParse(_amountText);

    if (_parsedAmount == null) {
      return;
    }

    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategory1!,
      categoryModel: _SelectedCategoryModel!,
    );

    await TransactionDB.interface.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDB.interface.refreshTransaction();
  }
}
