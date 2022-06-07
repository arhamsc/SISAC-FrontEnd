import 'package:flutter/material.dart';

import 'package:sisac/utils/general/screen_size.dart';
import 'package:expandable_page_view/expandable_page_view.dart';

import 'announcements_screen.dart';
import 'cafetaria_screen.dart';
import 'stationary_screen.dart';
import './time_table_screen.dart';
import 'home_screen.dart';

import '../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../widgets/component_widgets/scaffold/bottom_bar.dart';
import '../../../widgets/component_widgets/scaffold/app_drawer.dart';

/* Tab Screen - Contains the Scaffold and Bottom Navigation Bar for all the navigation pages(pages) */
class TabScreen extends StatefulWidget {
  static const routeName = '/home';
  const TabScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, dynamic>>? _pages;

  //current page index which is the Home Screen
  int _selectedPageIndex = 2;

  PageController? _tabController;

  @override
  void initState() {
    _tabController = PageController(initialPage: _selectedPageIndex);
    super.initState();
  }

  void selectPage(int index) {
    _tabController!.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    _selectedPageIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    //List of pages and their Screens to be rendered
    _pages = [
      {
        'page': TimeTableScreen(
          pageController: _tabController,
        ),
        'title': 'TimeTable'
      },
      {
        'page': AnnouncementScreen(
          pageController: _tabController!,
        ),
        'title': 'Announcements'
      },
      {
        'page': HomeScreen(
          pageController: _tabController!,
        ),
        'title': 'Home'
      },
      {
        'page': StationaryScreen(
          pageController: _tabController,
        ),
        'title': 'Stationary'
      },
      {
        'page': CafetariaScreen(
          pageController: _tabController,
        ),
        'title': 'Cafetaria'
      },
    ];

    return Scaffold(
      drawer: AppDrawer(
        pageController: _tabController!,
      ),
      appBar: BaseAppBar.getAppBar(
          title: _pages![_selectedPageIndex]['title'], context: context),
      body: ExpandablePageView(
        controller: _tabController,
        onPageChanged: (newPage) {
          setState(
            () {
              _selectedPageIndex = newPage;
            },
          );
        },
        //Dynamically rendered pages according to the bottom navigation bar
        children: _pages!
            .map(
              (element) => Container(
                constraints: BoxConstraints(
                  maxHeight: ScreenSize.usableHeight(context),
                ),
                child: element['page'] as Widget,
              ),
            )
            .toList(),
      ),
      extendBody: true,
      //Bottom navigation bar to render the pages
      bottomNavigationBar: BottomNavBar(
        currentPageIndex: _selectedPageIndex,
        selectPage: selectPage,
      ),
    );
  }
}
