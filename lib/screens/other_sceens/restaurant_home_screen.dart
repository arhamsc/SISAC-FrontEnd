import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './received_orders_screen.dart';

import '../../widgets/home/home_main_card.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/cafetaria/bottom_nav.dart';

import '../../utils/general/customColor.dart';
import '../../utils/general/screen_size.dart';

import '../../providers/cafetaria/restaurant_providers.dart';

class RestaurantHomeScreen extends StatelessWidget {
  static const routeName = 'cafetaria/restaurant';
  const RestaurantHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restP = Provider.of<RestaurantProvider>(context);
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
          title: "Restaurant", context: context, subtitle: "Home"),
      drawer: Drawer(),
      body: Column(
        children: [
          SizedBox(
            height: ScreenSize.usableHeight(context),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HomeMainCard(
                    mainTitle: "Received Orders",
                    buttonTitle: "Click to view",
                    buttonFunction: () {
                      Navigator.of(context)
                          .pushNamed(ReceivedOrdersScreen.routeName);
                    },
                    bgColor: SecondaryPallete.primary,
                  ),
                  HomeMainCard(
                    mainTitle: "Menu Availability",
                    buttonTitle: "Click to update menu",
                    buttonFunction: () {},
                    bgColor: SecondaryPallete.primary,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BottomNav(
              isSelected: "Cafetaria",
              showOnlyOne: true,
            ),
          ),
        ],
      ),
    );
  }
}
