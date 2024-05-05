import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cash_flow/db/Category/category_db.dart';
import 'package:cash_flow/models/Category/category_model.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().incomeCategorListNotifier,
      builder: (BuildContext ctx, List<CategoryModel> newList, Widget_) {
        return ListView.separated(
          padding: EdgeInsets.all(10.h),
          itemBuilder: (ctx, index) {
            final category = newList[index];
            return Card(
              child: ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  onPressed: () {
                    CategoryDB.instance.deleteCategory(category.id);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return SizedBox(height: 10.h);
          },
          itemCount: newList.length,
        );
      },
    );
  }
}
