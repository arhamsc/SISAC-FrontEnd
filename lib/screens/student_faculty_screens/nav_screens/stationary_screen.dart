import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../stationary/availability_screen.dart';
import '../stationary/books_material_screen.dart';
import '../stationary/material_available_screen.dart';

import '../../../widgets/component_widgets/home/home_main_card.dart';

import '../../../utils/general/screen_size.dart';
import '../../../utils/general/customColor.dart';

import '../../../providers/stationary/availability_providers.dart';

class StationaryScreen extends StatefulWidget {
  StationaryScreen({Key? key, required this.pageController}) : super(key: key);
  PageController? pageController;
  @override
  State<StationaryScreen> createState() => _StationaryScreenState();
}

class _StationaryScreenState extends State<StationaryScreen> {
  @override
  Widget build(BuildContext context) {
    final availP = Provider.of<AvailabilityProvider>(context);
    return Container(
      alignment: Alignment.center,
      height: ScreenSize.usableHeight(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HomeMainCard(
            mainTitle: "Availability",
            buttonTitle: "Click to visit",
            buttonFunction: () {
              Navigator.of(context).pushNamed(AvailabilityScreen.routeName);
            },
            bgColor: SecondaryPallete.primary,
          ),
          HomeMainCard(
            mainTitle: "Books",
            buttonTitle: "Click to visit",
            buttonFunction: () {
              Navigator.of(context).pushNamed(BooksMaterialScreen.routeName);
            },
            bgColor: SecondaryPallete.primary,
          ),
          HomeMainCard(
            mainTitle: "Material Available",
            buttonTitle: "Click to visit",
            buttonFunction: () {
              Navigator.of(context)
                  .pushNamed(MaterialAvailableScreen.routeName);
            },
            bgColor: SecondaryPallete.primary,
          ),
        ],
      ),
    );
  }
}
