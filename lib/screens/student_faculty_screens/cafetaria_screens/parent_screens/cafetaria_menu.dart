import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sisac/utils/general/customColor.dart';

import '../../../../providers/cafetaria/cafetaria_providers.dart';

import '../functional_screens/cart_screen.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/cafetaria/student_faculty/display_cards/menu_card.dart';
import '../../../../widgets/component_widgets/cafetaria/bottom_nav.dart';

import '../../../../utils/helpers/error_dialog.dart';
import '../../../../utils/general/screen_size.dart';
import '../../../../utils/helpers/http_exception.dart';

class CafetariaMenu extends StatefulWidget {
  const CafetariaMenu({Key? key}) : super(key: key);
  static const routeName = '/cafetaria/menu';

  @override
  State<CafetariaMenu> createState() => _CafetariaMenuState();
}

class _CafetariaMenuState extends State<CafetariaMenu> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final menuP = Provider.of<MenuItemProvider>(context, listen: false);
      menuP.getRecommendations();
    }());
    super.initState();
  }

  Future<void> _refreshItems(BuildContext context) async {
    setState(() {
      Provider.of<MenuItemProvider>(context, listen: false).fetchMenu();
    });
  }

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
            return const Center(child: CircularProgressIndicator());
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
                          itemBuilder: (ctx, i) => MenuCard(
                            menu: menuData.items[i],
                            preOrder: availability,
                            showBadge: menuData.recommendations.any((element) =>
                                element.itemId == menuData.items[i].id),
                          ),
                          itemCount: menuData.items.length,
                        ),
                      ),
                    ),
            );
          }
        },
      ),
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
      ),
    );
  }
}
