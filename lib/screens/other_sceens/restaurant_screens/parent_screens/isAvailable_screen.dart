import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/cafetaria/cafataria_providers.dart';

import '../updation_screens/add_edit_menuItem_screen.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/cafetaria/restaurant/isAvailable_cards.dart';
import '../../../../widgets/component_widgets/cafetaria/bottom_nav.dart';

import '../../../../../utils/helpers/error_dialog.dart';
import '../../../../../utils/general/screen_size.dart';

class IsAvailableScreen extends StatefulWidget {
  const IsAvailableScreen({Key? key}) : super(key: key);
  static const routeName = '/cafetaria/restaurant/isAvailable';

  @override
  State<IsAvailableScreen> createState() => _IsAvailableScreenState();
}

class _IsAvailableScreenState extends State<IsAvailableScreen> {
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
        subtitle: "Menu Available",
        showAddIcon: true,
        addButtonFunc: () {
          Navigator.of(context).pushNamed(AddEditMenuItemScreen.routeName, arguments: '');
        },
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
                          itemBuilder: (ctx, i) => IsAvailableCard(
                            menu: menuData.items[i],
                            setFunc: () {
                              setState(() {});
                            },
                            key: Key(menuData.items[i].id),
                          ),
                          itemCount: menuData.items.length,
                        ),
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
        },
      ),
    );
  }
}
