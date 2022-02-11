import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/general/customColor.dart';

/* Scaffold - Bottom Navigation Bar for Tab Screen of Student / Faculty */
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key? key,
    required this.currentPageIndex,
    required this.selectPage,
  }) : super(key: key);

  final int currentPageIndex;
  final void Function(int) selectPage;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<BottomNavigationBarItem> _navBarItems = [
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(
          top: 2.h,
        ),
        child: const Icon(Icons.calendar_today),
      ),
      label: '',
      backgroundColor: Palette.senaryDefault,
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(
          top: 2.h,
        ),
        child: const Icon(Icons.announcement_outlined),
      ),
      label: '',
      backgroundColor: Palette.senaryDefault,
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(
          top: 2.h,
        ),
        child: const Icon(Icons.home),
      ),
      label: '',
      backgroundColor: Palette.senaryDefault,
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(
          top: 2.h,
        ),
        child: const Icon(Icons.menu_book_outlined),
      ),
      label: '',
      backgroundColor: Palette.senaryDefault,
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(
          top: 2.h,
        ),
        child: const Icon(Icons.coffee_outlined),
      ),
      label: '',
      backgroundColor: Palette.senaryDefault,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      height: 10.h,
      //Clip to make the upper rounded borders
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        child: !Platform.isIOS
            ? Column(
                children: [
                  Expanded(
                    child: BottomNavigationBar(
                      items: _navBarItems,
                      unselectedItemColor: Palette.tertiaryDefault,
                      selectedItemColor: Palette.quinaryDefault,
                      showUnselectedLabels: true,
                      backgroundColor: Palette.senaryDefault,
                      iconSize: 20.sp,
                      onTap: widget.selectPage,
                      currentIndex: widget.currentPageIndex,
                      selectedIconTheme: IconThemeData(size: 24.sp),
                      type: BottomNavigationBarType.fixed,
                    ),
                  ),
                ],
              )
            : CupertinoTabBar(
                activeColor: Palette.quinaryDefault,
                inactiveColor: Palette.tertiaryDefault,
                items: _navBarItems,
                backgroundColor: Palette.senaryDefault,
                iconSize: 20.sp,
                onTap: widget.selectPage,
                currentIndex: widget.currentPageIndex,
              ),
      ),
    );
  }
}
