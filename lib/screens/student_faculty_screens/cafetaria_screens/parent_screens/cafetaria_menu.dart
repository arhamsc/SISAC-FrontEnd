import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sisac/utils/general/customColor.dart';
import 'package:sisac/utils/helpers/loader.dart';

import '../../../../providers/cafetaria/cafetaria_providers.dart';

import '../functional_screens/cart_screen.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/cafetaria/student_faculty/display_cards/menu_card.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';

import '../../../../utils/helpers/error_dialog.dart';

import '../../../../utils/general/screen_size.dart';

/* Cafetaria - Screen to view all Menu Items and Adding Menu Items to cart */
class CafetariaMenu extends StatefulWidget {
  const CafetariaMenu({Key? key}) : super(key: key);
  static const routeName = '/cafetaria/menu';

  @override
  State<CafetariaMenu> createState() => _CafetariaMenuState();
}

class _CafetariaMenuState extends State<CafetariaMenu> {
  @override
  void initState() {
    /* Fetching the Menu Items at the time of initial Rendering */
    Future.delayed(Duration.zero, () {
      final menuP = Provider.of<MenuItemProvider>(context, listen: false);
      menuP.getRecommendations();
    }());
    super.initState();
  }

  /* Pull To Refresh Function */
  Future<void> _refreshItems(BuildContext context) async {
    setState(() {
      Provider.of<MenuItemProvider>(context, listen: false).fetchMenu();
    });
  }

  //Date and Time Range Logic for pre order restriction
  DateTime now = DateTime.now();

  DateTime availableDurationStart = DateFormat('yyyy-MM-dd hh:mm:ss').parseLoose(
      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} 10:30:00');
  DateTime availableDurationEnd = DateFormat('yyyy-MM-dd hh:mm:ssa').parseLoose(
      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} 12:30:00');
  DateTimeRange get duration {
    return DateTimeRange(
        start: availableDurationStart, end: availableDurationEnd);
  }

  bool get availability {
    return now.isAfter(availableDurationStart) &&
            now.isBefore(availableDurationEnd)
        ? true
        : false;
  }

  @override
  Widget build(BuildContext context) {
    final pageController =
        ModalRoute.of(context)?.settings.arguments as PageController;
    final menuP = Provider.of<MenuItemProvider>(context, listen: false);
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Cafetaria",
        context: context,
        subtitle: "Menu",
        available: availability ? true : false,
        availabilityText: "PreOrder",
      ),
      body: FutureBuilder(
        future: menuP.fetchMenu(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: SISACLoader());
          } else if (dataSnapShot.error != null) {
            Future.delayed(
              Duration.zero,
              () => dialog(
                ctx: context,
                errorMessage: dataSnapShot.error.toString(),
                tryAgainFunc: () => _refreshItems(context),
                pop2Pages: true,
              ),
            );
            return RefreshIndicator(
              onRefresh: () => _refreshItems(context),
              child: const Center(
                child: Text("Error"),
              ),
            );
          } else {
            return Consumer<MenuItemProvider>(
              builder: (ctx, menuData, child) => RefreshIndicator(
                onRefresh: () => _refreshItems(context),
                child: SizedBox(
                  height: ScreenSize.usableHeight(context),
                  child: ListView.builder(
                    /* Card to render Menu Items */
                    itemBuilder: (ctx, i) => MenuCard(
                      menu: menuData.items[i],
                      preOrder: availability,
                      showBadge: menuData.recommendations.any(
                          (element) => element.itemId == menuData.items[i].id),
                    ),
                    itemCount: menuData.items.length,
                  ),
                ),
              ),
            );
          }
        },
      ),
      /* Add to Cart Button */
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CartScreen.routeName);
        },
        isExtended: false,
        child: const Icon(
          Icons.shopping_cart,
          color: SecondaryPallete.primary,
        ),
        backgroundColor: Palette.quinaryDefault,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: BottomNav(
        isSelected: "Cafetaria",
        pageController: pageController,
      ),
    );
  }
}
