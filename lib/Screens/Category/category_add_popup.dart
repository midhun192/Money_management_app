import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_management/db/Category/category_db.dart';
import 'package:money_management/models/Category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> CategoryAddPopUp(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  return showDialog(
    context: (context),
    builder: (ctx) {
      return SimpleDialog(
        title: const Text(
          'ADD CATEGORY',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(8.h),
            child: TextFormField(
              controller: _nameEditingController,
              decoration: const InputDecoration(
                hintText: 'Type Here',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.h),
            child: const Row(
              children: [
                RadioButton(title: 'Income', type: CategoryType.income),
                RadioButton(title: 'Expense', type: CategoryType.expense),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.h),
            child: ElevatedButton(
              onPressed: () {
                final _name = _nameEditingController.text;
                if (_name.isEmpty) {
                  return;
                } else {
                  final _type = selectedCategoryNotifier.value;
                  final _category = CategoryModel(
                    name: _name,
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    type: _type,
                  );
                  CategoryDB.instance.insertCategory(_category);
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Add'),
            ),
          )
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  const RadioButton({super.key, required this.title, required this.type});

  final String title;
  final CategoryType type;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder: (BuildContext ctx, CategoryType newCategory, Widget_) {
            return Radio<CategoryType>(
              value: type,
              groupValue: newCategory,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedCategoryNotifier.value = value;
                selectedCategoryNotifier.notifyListeners();
              },
            );
          },
        ),
        Text(title),
      ],
    );
  }
}
