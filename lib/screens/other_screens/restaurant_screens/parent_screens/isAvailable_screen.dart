import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/cafetaria/cafetaria_providers.dart';

import '../updation_screens/add_edit_menuItem_screen.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/cafetaria/restaurant/isAvailable_cards.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';

import '../../../../../utils/helpers/error_dialog.dart';
import '../../../../../utils/general/screen_size.dart';
import '../../../../../utils/helpers/http_exception.dart';
import '../../../../utils/helpers/confirmation_dialog.dart';

/* Restaurant - Menu Item Availability Updation Screen */
class IsAvailableScreen extends StatefulWidget {
  const IsAvailableScreen({Key? key}) : super(key: key);
  static const routeName = '/cafetaria/restaurant/isAvailable';

  @override
  State<IsAvailableScreen> createState() => _IsAvailableScreenState();
}

class _IsAvailableScreenState extends State<IsAvailableScreen> {
  bool _isLoading = false;
  /* Delete Menu Item Handler */
  Future<void> _deleteMenuFunc(MenuItemProvider menuP, String id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await menuP.deleteMenuItem(id);
      setState(() {
        _isLoading = false;
      });
      await dialog(
        ctx: context,
        errorMessage: "Menu Item Deleted",
        title: "Success",
      );
    } on HttpException catch (error) {
      await dialog(
        ctx: context,
        errorMessage: error.message,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  /* Show Confirmation Dialog */
  Future<void> _showDeleteDialog(MenuItemProvider menuP, String id) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: "Are you sure?",
          content: "Deleting a menu item.",
          confirmationFunction: () => _deleteMenuFunc(menuP, id),
        );
      },
    );
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
          Navigator.of(context)
              .pushNamed(AddEditMenuItemScreen.routeName, arguments: '');
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
                tryAgainFunc: () => setState(() async {
                  await Provider.of<MenuItemProvider>(context, listen: false)
                      .fetchMenu();
                }),
                pop2Pages: true,
              ),
            );
            return RefreshIndicator(
              onRefresh: () async {
                setState(
                  () async {
                    await Provider.of<MenuItemProvider>(context, listen: false)
                        .fetchMenu();
                  },
                );
              },
              child: const Center(
                child: Text("Error"),
              ),
            );
          } else {
            return Consumer<MenuItemProvider>(
              builder: (ctx, menuData, child) => _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  /* Refresh Indicator to use pull to refresh */
                  : RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          menuData.fetchMenu();
                        });
                      },
                      child: SizedBox(
                        height: ScreenSize.usableHeight(context),
                        child: ListView.builder(
                          /* Card widget to render the Menu Items with Necessary Details */
                          itemBuilder: (ctx, i) => IsAvailableCard(
                            menu: menuData.items[i],
                            setFunc: () {
                              setState(() {});
                            },
                            deleteFunc: () => _showDeleteDialog(
                              menuData,
                              menuData.items[i].id,
                            ),
                            key: Key(menuData.items[i].id),
                          ),
                          itemCount: menuData.items.length,
                        ),
                      ),
                    ),
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNav(
        isSelected: "Cafetaria",
        showOnlyOne: true,
      ),
    );
  }
}
