import "package:flutter/material.dart";

import '../stationary/availability_screen.dart';
import '../stationary/books_material_screen.dart';
import '../stationary/material_available_screen.dart';

import '../../../widgets/component_widgets/home/home_main_card.dart';

import '../../../utils/general/screen_size.dart';
import '../../../utils/general/customColor.dart';

/* Stationary - Navigation Screen */
class StationaryScreen extends StatefulWidget {
  const StationaryScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController? pageController;
  @override
  State<StationaryScreen> createState() => _StationaryScreenState();
}

class _StationaryScreenState extends State<StationaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: ScreenSize.usableHeight(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //Availability Widget
          HomeMainCard(
            mainTitle: "Availability",
            buttonTitle: "Click to visit",
            buttonFunction: () {
              Navigator.of(context).pushNamed(
                AvailabilityScreen.routeName,
                arguments: widget.pageController,
              );
            },
            bgColor: SecondaryPallete.primary,
          ),
          //Books Widget
          HomeMainCard(
            mainTitle: "Books",
            buttonTitle: "Click to visit",
            buttonFunction: () {
              Navigator.of(context).pushNamed(
                BooksMaterialScreen.routeName,
                arguments: widget.pageController,
              );
            },
            bgColor: SecondaryPallete.primary,
          ),
          //Material Widget
          HomeMainCard(
            mainTitle: "Material Available",
            buttonTitle: "Click to visit",
            buttonFunction: () {
              Navigator.of(context).pushNamed(
                MaterialAvailableScreen.routeName,
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
