import 'package:flutter/material.dart';
import 'package:money_management/Screens/Category/category_add_popup.dart';
import 'package:money_management/Screens/Category/screen_category.dart';
import 'package:money_management/Screens/Transaction/add_transaction.dart';
import 'package:money_management/Screens/Transaction/screen_transaction.dart';
import 'package:money_management/Screens/home/widgets/bottomNavigation.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = [
    const ScreenTransaction(),
    const ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Money Manager',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 120, 111, 166),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (BuildContext ctx, int updatedIndex, widget_) {
            return _pages[updatedIndex];
          },
        ),
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          } else {
            CategoryAddPopUp(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
