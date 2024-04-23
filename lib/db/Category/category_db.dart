import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management/models/Category/category_model.dart';

const CATEGORY_DB_NAME = 'category_database';

abstract class CategoryDBFunctions {
  Future<List<CategoryModel>> getCategory();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryID);
}

class CategoryDB implements CategoryDBFunctions {
  CategoryDB.internal();
  static CategoryDB instance = CategoryDB.internal();

  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategorListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListNotifier =
      ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _category_DB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _category_DB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategory() async {
    final _category_DB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _category_DB.values.toList();
  }

  Future<void> refreshUI() async {
    final _getAllCategories = await getCategory();
    incomeCategorListNotifier.value.clear();
    expenseCategoryListNotifier.value.clear();
    Future.forEach(_getAllCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategorListNotifier.value.add(category);
      } else {
        expenseCategoryListNotifier.value.add(category);
      }
    });
    incomeCategorListNotifier.notifyListeners();
    expenseCategoryListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _category_DB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _category_DB.delete(categoryID);
    refreshUI();
  }
}
