import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cash_flow/Screens/home/screen_home.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedIndex, Widget_) {
        return CurvedNavigationBar(
          // height: 65.h,
          animationCurve: Curves.fastEaseInToSlowEaseOut,
          animationDuration: const Duration(milliseconds: 300),
          index: updatedIndex,
          backgroundColor: Colors.grey.shade300,
          color: const Color.fromARGB(255, 120, 111, 166),
          items: const [
            CurvedNavigationBarItem(
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: 'Transaction',
              labelStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.category,
                color: Colors.white,
              ),
              label: 'Category',
              labelStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          onTap: (value) {
            ScreenHome.selectedIndexNotifier.value = value;
          },
        );
      },
    );
  }
}
