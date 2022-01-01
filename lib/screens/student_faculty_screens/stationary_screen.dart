import "package:flutter/material.dart";

import '../../widgets/home/home_main_card.dart';

import '../../utils/general/screen_size.dart';
import '../../utils/general/customColor.dart';

class StationaryScreen extends StatelessWidget {
  const StationaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: ScreenSize.usableHeight(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HomeMainCard(
            mainTitle: "Availability",
            buttonTitle: "Click to visit",
            buttonFunction: () {},
            bgColor: SecondaryPallete.primary,
          ),
          HomeMainCard(
            mainTitle: "Books",
            buttonTitle: "Click to visit",
            buttonFunction: () {},
            bgColor: SecondaryPallete.primary,
          ),
          HomeMainCard(
            mainTitle: "Material Available",
            buttonTitle: "Click to visit",
            buttonFunction: () {},
            bgColor: SecondaryPallete.primary,
          ),
        ],
      ),
    );
  }
}
