import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cafetaria/cafataria_providers.dart';

import './cafetaria_menu.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/cafetaria/bottom_nav.dart';
import '../../../widgets/cafetaria/rating_card.dart';
import '../../../widgets/cafetaria/order_card.dart';

import '../../../utils/helpers/error_dialog.dart';
import '../../../utils/general/screen_size.dart';

class RatingScreen extends StatefulWidget {
  static const routeName = '/cafetaria/ratings';
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  Future<void> _refreshItems(BuildContext context) async {
    return await Provider.of<MenuItemProvider>(context, listen: false)
        .fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    //final orderP = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
          title: "Cafetaria", context: context, subtitle: "Orders"),
      body: FutureBuilder(
        future:
            Provider.of<MenuItemProvider>(context, listen: false).fetchMenu(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (dataSnapShot.error != null) {
            Future.delayed(Duration.zero, () {
              print(dataSnapShot.error);
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
