import 'package:flutter/material.dart';

import './update_availability_screen.dart';
import './books_material_screen.dart';
import './material_available_screen.dart';

import '../../../../widgets/component_widgets/home/home_main_card.dart';
import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';
import '../../../../widgets/component_widgets/stationary/vendor/stationary_drawer.dart';

import '../../../../utils/general/customColor.dart';
import '../../../../utils/general/screen_size.dart';

/* Stationary - Vendor Side Home Screen */
class StationaryHomeScreen extends StatelessWidget {
  static const routeName = 'stationary/vendor';
  const StationaryHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Stationary",
        context: context,
        subtitle: "Home - Vendor",
      ),
      drawer: const StationaryDrawer(),
      body: SizedBox(
        height: ScreenSize.usableHeight(context),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: ScreenSize.screenHeight(context) * .01,
                ),
                //Bluebook/Record Availability Updation Screen Widget
                HomeMainCard(
                  mainTitle: "Availability",
                  buttonTitle: "Click to view",
                  buttonFunction: () {
                    Navigator.of(context).pushNamed(
                      UpdateAvailabilityScreen.routeName,
                    );
                  },
                  bgColor: SecondaryPallete.primary,
                ),
                SizedBox(
                  height: ScreenSize.screenHeight(context) * .02,
                ),
                // Books Updation Screen Widget
                HomeMainCard(
                  mainTitle: "Books",
                  buttonTitle: "Click to update books",
                  buttonFunction: () {
                    Navigator.of(context).pushNamed(
                      VendorBooksMaterialScreen.routeName,
                    );
                  },
                  bgColor: SecondaryPallete.primary,
                ),
                SizedBox(
                  height: ScreenSize.screenHeight(context) * .02,
                ),
                // Material Updation Screen Widget
                HomeMainCard(
                  mainTitle: "Material",
                  buttonTitle: "Click to update material",
                  buttonFunction: () {
                    Navigator.of(context).pushNamed(
                      VendorMaterialAvailableScreen.routeName,
                    );
                  },
                  bgColor: SecondaryPallete.primary,
                ),
                SizedBox(
                  height: ScreenSize.screenHeight(context) * .02,
                ),
                // Orders Updation Screen Widget
                HomeMainCard(
                  mainTitle: "Received Orders",
                  buttonTitle: "Click to view orders",
                  buttonFunction: () {},
                  bgColor: SecondaryPallete.primary,
                ),
                SizedBox(
                  height: ScreenSize.screenHeight(context) * .01,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(
        isSelected: "Stationary",
        showOnlyOne: true,
      ),
    );
  }
}
