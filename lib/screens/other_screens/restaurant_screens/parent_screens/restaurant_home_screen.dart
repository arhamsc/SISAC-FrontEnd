import 'package:flutter/material.dart';

import 'received_orders_screen.dart';
import 'isAvailable_screen.dart';

import '../../../../widgets/component_widgets/home/home_main_card.dart';
import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';
import '../../../../widgets/component_widgets/cafetaria/restaurant/restaurant_drawer.dart';

import '../../../../utils/general/customColor.dart';
import '../../../../utils/general/screen_size.dart';

/* Restaurant - Home Screen */
class RestaurantHomeScreen extends StatelessWidget {
  static const routeName = 'cafetaria/restaurant';
  const RestaurantHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Restaurant",
        context: context,
        subtitle: "Home",
      ),
      drawer: const RestaurantDrawer(),
      body: SizedBox(
        height: ScreenSize.usableHeight(context),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /* Received Orders Widget */
              HomeMainCard(
                mainTitle: "Received Orders",
                buttonTitle: "Click to view",
                buttonFunction: () {
                  Navigator.of(context).pushNamed(
                    ReceivedOrdersScreen.routeName,
                  );
                },
                bgColor: SecondaryPallete.primary,
              ),
              /* Menu Updation Widget */
              HomeMainCard(
                mainTitle: "Menu Availability",
                buttonTitle: "Click to update menu",
                buttonFunction: () {
                  Navigator.of(context).pushNamed(IsAvailableScreen.routeName);
                },
                bgColor: SecondaryPallete.primary,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(
        isSelected: "Cafetaria",
        showOnlyOne: true,
      ),
    );
  }
}
