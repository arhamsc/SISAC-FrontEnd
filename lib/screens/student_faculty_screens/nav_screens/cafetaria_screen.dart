import "package:flutter/material.dart";

import '../../../utils/general/screen_size.dart';
import '../../../utils/general/customColor.dart';

import '../cafetaria_screens/parent_screens/cafetaria_menu.dart';
import '../cafetaria_screens/parent_screens/order_screen.dart';
import '../cafetaria_screens/parent_screens/rating_screen.dart';

import '../../../widgets/component_widgets/home/home_main_card.dart';

/* Cafetaria - Navigation Screen */
class CafetariaScreen extends StatefulWidget {
  const CafetariaScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController? pageController;
  @override
  State<CafetariaScreen> createState() => _CafetariaScreenState();
}

class _CafetariaScreenState extends State<CafetariaScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: ScreenSize.usableHeight(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //Menu Item Widget
          HomeMainCard(
            mainTitle: "Menu",
            buttonTitle: "Click to visit",
            buttonFunction: () {
              Navigator.of(context).pushNamed(
                CafetariaMenu.routeName,
                arguments: widget.pageController,
              );
            },
            bgColor: SecondaryPallete.primary,
          ),
          //View Orders Widget
          HomeMainCard(
            mainTitle: "Orders",
            buttonTitle: "Click to visit",
            buttonFunction: () {
              Navigator.of(context).pushNamed(
                OrderScreen.routeName,
                arguments: widget.pageController,
              );
            },
            bgColor: SecondaryPallete.primary,
          ),
          //Rate Menu Item Widget
          HomeMainCard(
            mainTitle: "Rating",
            buttonTitle: "Click to visit",
            buttonFunction: () {
              Navigator.of(context).pushNamed(
                RatingScreen.routeName,
                arguments: widget.pageController,
              );
            },
            bgColor: SecondaryPallete.primary,
          ),
        ],
      ),
    );
  }
}
