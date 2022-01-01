import 'package:flutter/material.dart';

import './announcements_screen.dart';
import './cafetaria_screen.dart';
import './stationary_screen.dart';
import './time_table_screen.dart';
import './home_screen.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/bottom_bar.dart';

class TabScreen extends StatefulWidget {
  static const routeName = '/home';
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, dynamic>>? _pages;
  int _selectedPageIndex = 2;
  @override
  void initState() {
    _pages = [
      {'page': const TimeTableScreen(), 'title': 'TimeTable'},
      {'page': const AnnouncementScreen(), 'title': 'Announcements'},
      {'page': HomeScreen(), 'title': 'Home'},
      {'page': const StationaryScreen(), 'title': 'Stationary'},
      {'page': const CafetariaScreen(), 'title': 'Cafetaria'},
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar:
          BaseAppBar.getAppBar(title: _pages![_selectedPageIndex]['title'], context: context),
      body: _pages![_selectedPageIndex]['page'],
      extendBody: true,
      bottomNavigationBar: BottomNavBar(
        currentPageIndex: _selectedPageIndex,
        selectPage: _selectPage,
      ),
    );
  }
}
