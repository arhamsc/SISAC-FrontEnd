import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cafetaria/cafataria_providers.dart';

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
  var _expanded = false;

  Future<void> _refreshItems(BuildContext context) async {
    return await Provider.of<MenuItemProvider>(context, listen: false)
        .fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
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
                    builder: (ctx, menuData, child) => Container(
                      child: SingleChildScrollView(
                        child: Container(
                          height: ScreenSize.usableHeight(context),
                          child: ListView.builder(
                            itemBuilder: (ctx, i) =>
                                MenuCard(menu: menuData.items[i]),
                            itemCount: menuData.items.length,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: BottomNav(
                      isSelected: "Cafetaria",
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
