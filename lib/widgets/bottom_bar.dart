import 'package:flutter/material.dart';

import '../utils/general/customColor.dart';
import '../utils/general/screen_size.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar(
      {Key? key, required this.currentPageIndex, required this.selectPage})
      : super(key: key);

  int currentPageIndex;
  final void Function(int) selectPage;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      height: ScreenSize.screenHeight(context) * 0.1,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.only(bottom: 25),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0,
                  color: Palette.senaryDefault,
                ),
                color: Palette.senaryDefault,
              ),
            ),
            BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: '',
                  backgroundColor: Palette.senaryDefault,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.announcement_outlined),
                  label: '',
                  backgroundColor: Palette.senaryDefault,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '',
                  backgroundColor: Palette.senaryDefault,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_outlined),
                  label: '',
                  backgroundColor: Palette.senaryDefault,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.coffee_outlined),
                  label: '',
                  backgroundColor: Palette.senaryDefault,
                ),
              ],
              unselectedItemColor: Palette.tertiaryDefault,
              selectedItemColor: Palette.quinaryDefault,
              showUnselectedLabels: true,
              backgroundColor: Palette.senaryDefault,
              iconSize: 24,
              onTap: widget.selectPage,
              currentIndex: widget.currentPageIndex,
              selectedIconTheme: const IconThemeData(size: 30),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0,
                    color: Palette.senaryDefault,
                  ),
                  color: Palette.senaryDefault,
                ),
                margin: const EdgeInsets.all(0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
