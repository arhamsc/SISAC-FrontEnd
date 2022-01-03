import 'package:flutter/material.dart';

import '../../../utils/general/customColor.dart';
import '../../../utils/general/screen_size.dart';

class BottomNav extends StatefulWidget {
  BottomNav({Key? key, required this.isSelected, this.showOnlyOne})
      : super(key: key);

  String isSelected;
  bool? showOnlyOne;

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  String get selectedIcon {
    var selected;
    switch (widget.isSelected) {
      case "TimeTable":
        selected = "TimeTable";
        break;
      case "Announcements":
        selected = "Announcements";
        break;
      case "Home":
        selected = "Home";
        break;
      case "Stationary":
        selected = "Stationary";
        break;
      case "Cafetaria":
        selected = "Cafetaria";
        break;
    }
    return selected;
  }

  bool get _showOnlyOne {
    return widget.showOnlyOne != null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.screenHeight(context) * 0.1,
      decoration: const BoxDecoration(
        color: Palette.senaryDefault,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: !_showOnlyOne
            ? MainAxisAlignment.spaceAround
            : MainAxisAlignment.center,
        children: [
          // TODO: Implement Navigation to the main screen in each buttons
          _showOnlyOne && selectedIcon == 'TimeTable'
              ? IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {},
                  color: selectedIcon == "TimeTable"
                      ? Palette.quinaryDefault
                      : Palette.tertiaryDefault,
                  iconSize: selectedIcon == "TimeTable" ? 30 : 24,
                )
              : const SizedBox(),
          _showOnlyOne && selectedIcon == 'Announcements'
              ? IconButton(
                  icon: Icon(Icons.announcement_outlined),
                  onPressed: () {},
                  color: selectedIcon == "Announcements"
                      ? Palette.quinaryDefault
                      : Palette.tertiaryDefault,
                  iconSize: selectedIcon == "Announcements" ? 30 : 24,
                )
              : const SizedBox(),
          _showOnlyOne && selectedIcon == 'Home'
              ? IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {},
                  color: selectedIcon == "Home"
                      ? Palette.quinaryDefault
                      : Palette.tertiaryDefault,
                  iconSize: selectedIcon == "Home" ? 30 : 24,
                )
              : const SizedBox(),
          _showOnlyOne && selectedIcon == 'Stationary'
              ? IconButton(
                  icon: Icon(Icons.menu_book_outlined),
                  onPressed: () {},
                  color: selectedIcon == "Stationary"
                      ? Palette.quinaryDefault
                      : Palette.tertiaryDefault,
                  iconSize: selectedIcon == "Stationary" ? 30 : 24,
                )
              : const SizedBox(),
          _showOnlyOne && selectedIcon == 'Cafetaria'
              ? IconButton(
                  icon: Icon(Icons.coffee_outlined),
                  onPressed: () {},
                  color: selectedIcon == "Cafetaria"
                      ? Palette.quinaryDefault
                      : Palette.tertiaryDefault,
                  iconSize: selectedIcon == "Cafetaria" ? 30 : 24,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
