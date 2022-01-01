import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../providers/cafetaria/cafataria_providers.dart';

import '../../utils/general/screen_size.dart';
import '../../utils/general/customColor.dart';

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
              buttonFunction: () {},
              bgColor: SecondaryPallete.primary,
            ),
            HomeMainCard(
              mainTitle: "Orders",
              buttonTitle: "Click to visit",
              buttonFunction: () {},
              bgColor: SecondaryPallete.primary,
            ),
            HomeMainCard(
              mainTitle: "Rating",
              buttonTitle: "Click to visit",
              buttonFunction: () {},
              bgColor: SecondaryPallete.primary,
            ),
            ElevatedButton(onPressed: menuItem.fetchMenu, child: Text("Click"))
          ],
        ),
      ),
    );
  }
}
