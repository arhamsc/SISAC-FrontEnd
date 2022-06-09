import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/general/customColor.dart';

/* Bottom Navigation Bar for Any Child Screen */
class BottomNav extends StatefulWidget {
  const BottomNav({
    Key? key,
    required this.isSelected,
    this.showOnlyOne,
    this.pageController,
  }) : super(key: key);

  final String isSelected;
  final bool? showOnlyOne;
  final PageController? pageController;

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  /* Getter to get the current selected screen */
  String get selectedIcon {
    String selected = "";
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

  //Show only one if there is a specific role
  bool get _showOnlyOne {
    return widget.showOnlyOne != null;
  }

  void _iconOnPressHandler(int index) {
    widget.pageController != null
        ? {
            Navigator.of(context).pop(),
            widget.pageController!.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            )
          }
        : null;
  }

  Color _iconColor(String screenName) {
    Color color = Palette.tertiaryDefault;
    selectedIcon == screenName
        ? color = Palette.quinaryDefault
        : color = Palette.tertiaryDefault;
    return color;
  }

  double _iconSize(String screenName) {
    double size = 20.sp;
    selectedIcon == screenName ? size = 24.sp : size;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    //Widget map according to the current screen
    Map<String, Widget> widgetSelector = {
      'TimeTable': IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () => _iconOnPressHandler(0),
        color: _iconColor("TimeTable"),
        iconSize: _iconSize("TimeTable"),
      ),
      'Announcements': IconButton(
        icon: const Icon(Icons.announcement_outlined),
        onPressed: () => _iconOnPressHandler(1),
        color: _iconColor("Announcements"),
        iconSize: _iconSize("Announcements"),
      ),
      'Home': IconButton(
        icon: const Icon(Icons.home),
        onPressed: () => _iconOnPressHandler(2),
        color: _iconColor("Home"),
        iconSize: _iconSize("Home"),
      ),
      'Stationary': IconButton(
        icon: const Icon(Icons.menu_book_outlined),
        onPressed: () => _iconOnPressHandler(3),
        color: _iconColor("Stationary"),
        iconSize: _iconSize("Stationary"),
      ),
      'Cafetaria': IconButton(
        icon: const Icon(Icons.coffee_outlined),
        onPressed: () => _iconOnPressHandler(4),
        color: _iconColor("Cafetaria"),
        iconSize: _iconSize("Cafetaria"),
      ),
    };

    //Showing the particular icon if only one is true
    List<Widget>? showIcon(String selected, bool showOnlyOne) {
      if (_showOnlyOne && _showOnlyOne == true) {
        List<Widget> returningWid = [];
        switch (selected) {
          case 'TimeTable':
            returningWid.add(widgetSelector['TimeTable']!);
            break;
          case 'Announcements':
            returningWid.add(widgetSelector['Announcements']!);
            break;
          case 'Home':
            returningWid.add(widgetSelector['Home']!);
            break;
          case 'Stationary':
            returningWid.add(widgetSelector['Stationary']!);
            break;
          case 'Cafetaria':
            returningWid.add(widgetSelector['Cafetaria']!);
            break;
          default:
            const SizedBox();
        }
        return returningWid;
      } else {
        List<Widget> returningWid = [];
        for (var v in widgetSelector.values) {
          returningWid.add(v);
        }
        return returningWid;
      }
    }

    return Container(
      height: 10.h,
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
        children: showIcon(selectedIcon, _showOnlyOne)!.toList(),
      ),
    );
  }
}
