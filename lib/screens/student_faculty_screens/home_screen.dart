import 'package:flutter/material.dart';

import './tab_screen.dart';

import '../../widgets/home/home_main_card.dart';
import '../../widgets/home/home_row_cards.dart';

import '../../utils/general/screen_size.dart';
import '../../utils/general/customColor.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.pageController}) : super(key: key);

  PageController pageController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appBarHeight = AppBar().preferredSize.height;

  @override
  Widget build(BuildContext context) {
    final bottomHeight = ScreenSize.screenHeight(context) * 0.17;
    //final authData = Provider.of<Auth>(context);
    final screenHeight =
        MediaQuery.of(context).size.height - appBarHeight - bottomHeight;
    return SingleChildScrollView(
      child: Container(
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomeMainCard(
              mainTitle: "Time Table",
              buttonTitle: "Click to View",
              buttonFunction: () {
                widget.pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
            Container(
              child: Column(
                children: [
                  HomeRowCards(
                    pageController: widget.pageController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.chevron_left, color: Palette.quinaryDefault),
                      Icon(Icons.chevron_right, color: Palette.quinaryDefault),
                    ],
                  ),
                ],
              ),
            ),
            HomeMainCard(
              mainTitle: "Cafetaria",
              buttonTitle: "Click to visit",
              buttonFunction: () {
                widget.pageController.animateToPage(
                  4,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              bgColor: SecondaryPallete.tertiary,
            ),
          ],
        ),
      ),
    );
  }
}

// ElevatedButton(
//             child: const Text("Logout"),
//             onPressed: () {
//               authData.logout();
//               if (!authData.isAuth) {
//                 Navigator.popUntil(context, ModalRoute.withName("/"));
//               }
//             },
//           ),
