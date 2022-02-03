import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/cafetaria/cafetaria_providers.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';
import '../../../../widgets/component_widgets/cafetaria/student_faculty/display_cards/rating_card.dart';

import '../../../../utils/helpers/error_dialog.dart';
import '../../../../utils/general/screen_size.dart';

/* Cafetaria - Screen to Rate Menu Item */
class RatingScreen extends StatefulWidget {
  static const routeName = '/cafetaria/ratings';
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  /* Pull to Refresh Function */
  Future<void> _refreshItems(BuildContext context) async {
    setState(() {
      Provider.of<MenuItemProvider>(context, listen: false).fetchMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageController =
        ModalRoute.of(context)?.settings.arguments as PageController;
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Cafetaria",
        context: context,
        subtitle: "Orders",
      ),
      body: FutureBuilder(
        future:
            Provider.of<MenuItemProvider>(context, listen: false).fetchMenu(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (dataSnapShot.error != null) {
            Future.delayed(Duration.zero, () {
              dialog(
                ctx: context,
                errorMessage: dataSnapShot.error.toString(),
                tryAgainFunc: () => _refreshItems(context),
                pop2Pages: true,
              );
            });

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
                    itemBuilder: (ctx, i) => RatingCard(
                      key: Key(menuData.items[i].id),
                      menu: menuData.items[i],
                      setStateFunc: () {
                        setState(() {});
                      },
                    ),
                    itemCount: menuData.items.length,
                  ),
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNav(
        isSelected: "Cafetaria",
        pageController: pageController,
      ),
    );
  }
}
