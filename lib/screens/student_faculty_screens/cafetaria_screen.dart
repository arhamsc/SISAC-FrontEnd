import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../providers/cafetaria/cafataria_providers.dart';

import '../../utils/general/screen_size.dart';
import '../../utils/general/customColor.dart';

import './cafetaria_screens/cafetaria_menu.dart';
import './cafetaria_screens/order_screen.dart';
import './cafetaria_screens/rating_screen.dart';

import '../../widgets/home/home_main_card.dart';

class CafetariaScreen extends StatelessWidget {
  const CafetariaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: ScreenSize.usableHeight(context),
      child: Consumer<MenuItemProvider>(
        builder: (ctx, menuItem, _) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomeMainCard(
              mainTitle: "Menu",
              buttonTitle: "Click to visit",
              buttonFunction: () {
                Navigator.of(context).pushNamed(CafetariaMenu.routeName);
              },
              bgColor: SecondaryPallete.primary,
            ),
            HomeMainCard(
              mainTitle: "Orders",
              buttonTitle: "Click to visit",
              buttonFunction: () {
                Navigator.of(context).pushNamed(OrderScreen.routeName);
              },
              bgColor: SecondaryPallete.primary,
            ),
            HomeMainCard(
              mainTitle: "Rating",
              buttonTitle: "Click to visit",
              buttonFunction: () {
                Navigator.of(context).pushNamed(RatingScreen.routeName);
              },
              bgColor: SecondaryPallete.primary,
            ),
          ],
        ),
      ),
    );
  }
}
/** 
 * Navigation while keeping the bottom bar.
 * return Navigator(
      onGenerateRoute: (settings) {
        Widget mainScreen = MainScreen();
        if (settings.name == 'menu') mainScreen = CafetariaMenu();
        return MaterialPageRoute(builder: (_) => mainScreen);
      },
    );
 * **/