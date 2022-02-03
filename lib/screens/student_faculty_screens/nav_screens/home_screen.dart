import 'package:flutter/material.dart';

import '../../../widgets/component_widgets/home/home_main_card.dart';
import '../../../widgets/component_widgets/home/home_row_cards.dart';

import '../../../utils/general/screen_size.dart';
import '../../../utils/general/customColor.dart';

/* Student / Faculty - Home Screen */
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appBarHeight = AppBar().preferredSize.height;

  @override
  Widget build(BuildContext context) {
    final bottomHeight = ScreenSize.screenHeight(context) * 0.17;
    final screenHeight =
        MediaQuery.of(context).size.height - appBarHeight - bottomHeight;
    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //Time Table WIdget
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
            Column(
              children: [
                //Row of Cards
                HomeRowCards(
                  pageController: widget.pageController,
                ),
                //Sideways Scroll Arrow Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.chevron_left, color: Palette.quinaryDefault),
                    Icon(Icons.chevron_right, color: Palette.quinaryDefault),
                  ],
                ),
              ],
            ),
            //Cafetaria Widget
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
