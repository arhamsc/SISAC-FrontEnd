import 'package:flutter/material.dart';

import '../../../../utils/general/customColor.dart';
import '../../../../utils/general/screen_size.dart';

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

  //Show only one if there is a specific role
  bool get _showOnlyOne {
    return widget.showOnlyOne != null;
  }

  @override
  Widget build(BuildContext context) {
    //Widget map according to the current screen
    Map<String, Widget> widgetSelector = {
      'TimeTable': IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () {
          widget.pageController != null
              ? {
                  Navigator.of(context).pop(),
                  widget.pageController!.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  )
                }
              : null;
        },
        color: selectedIcon == "TimeTable"
            ? Palette.quinaryDefault
            : Palette.tertiaryDefault,
        iconSize: selectedIcon == "TimeTable" ? 30 : 24,
      ),
      'Announcements': IconButton(
        icon: const Icon(Icons.announcement_outlined),
        onPressed: () {
          widget.pageController != null
              ? {
                  Navigator.of(context).pop(),
                  widget.pageController!.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  )
                }
              : null;
        },
        color: selectedIcon == "Announcements"
            ? Palette.quinaryDefault
            : Palette.tertiaryDefault,
        iconSize: selectedIcon == "Announcements" ? 30 : 24,
      ),
      'Home': IconButton(
        icon: const Icon(Icons.home),
        onPressed: () {
          widget.pageController != null
              ? {
                  Navigator.of(context).pop(),
                  widget.pageController!.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  )
                }
              : null;
        },
        color: selectedIcon == "Home"
            ? Palette.quinaryDefault
            : Palette.tertiaryDefault,
        iconSize: selectedIcon == "Home" ? 30 : 24,
      ),
      'Stationary': IconButton(
        icon: const Icon(Icons.menu_book_outlined),
        onPressed: () {
          widget.pageController != null
              ? {
                  Navigator.of(context).pop(),
                  widget.pageController!.animateToPage(
                    3,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  )
                }
              : null;
        },
        color: selectedIcon == "Stationary"
            ? Palette.quinaryDefault
            : Palette.tertiaryDefault,
        iconSize: selectedIcon == "Stationary" ? 30 : 24,
      ),
      'Cafetaria': IconButton(
        icon: const Icon(Icons.coffee_outlined),
        onPressed: () {
          widget.pageController != null
              ? {
                  Navigator.of(context).pop(),
                  widget.pageController!.animateToPage(
                    4,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  )
                }
              : null;
        },
        color: selectedIcon == "Cafetaria"
            ? Palette.quinaryDefault
            : Palette.tertiaryDefault,
        iconSize: selectedIcon == "Cafetaria" ? 30 : 24,
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
        children:
            // TODO: Implement Navigation to the main screen in each buttons
            showIcon(selectedIcon, _showOnlyOne)!.toList(),
      ),
    );
  }
}
