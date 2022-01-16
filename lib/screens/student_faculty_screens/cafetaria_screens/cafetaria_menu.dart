import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisac/utils/general/customColor.dart';

import '../../../providers/cafetaria/cafataria_providers.dart';

import './cart_screen.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/cafetaria/menu_card.dart';
import '../../../widgets/cafetaria/bottom_nav.dart';

import '../../../utils/helpers/error_dialog.dart';
import '../../../utils/general/screen_size.dart';

class CafetariaMenu extends StatefulWidget {
  const CafetariaMenu({Key? key}) : super(key: key);
  static const routeName = '/cafetaria/menu';

  @override
  State<CafetariaMenu> createState() => _CafetariaMenuState();
}

class _CafetariaMenuState extends State<CafetariaMenu> {

  Future<void> _refreshItems(BuildContext context) async {
    return await Provider.of<MenuItemProvider>(context, listen: false)
        .fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Cafetaria",
        context: context,
        subtitle: "Menu",
        // TODO: Implement time range
        available: true,
        availabilityText: "PreOrder",
      ),
      body: FutureBuilder(
        future:
            Provider.of<MenuItemProvider>(context, listen: false).fetchMenu(),
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
            return RefreshIndicator(
              onRefresh: () => _refreshItems(context),
              child: Column(
                children: [
                  Consumer<MenuItemProvider>(
                    builder: (ctx, menuData, child) => SingleChildScrollView(
                      child: SizedBox(
                        height: ScreenSize.usableHeight(context),
                        child: ListView.builder(
                          itemBuilder: (ctx, i) =>
                              MenuCard(menu: menuData.items[i]),
                          itemCount: menuData.items.length,
                        ),
                      ),
                    ),
                  ),
                ],
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
