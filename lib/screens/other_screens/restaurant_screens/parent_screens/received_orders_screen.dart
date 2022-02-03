import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/cafetaria/cafetaria_providers.dart';
import '../../../../providers/cafetaria/restaurant_providers.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';
import '../../../../widgets/component_widgets/cafetaria/restaurant/received_orders_card.dart';

import '../../../../../utils/helpers/error_dialog.dart';
import '../../../../../utils/general/screen_size.dart';

/* Restaurant - View and Delete Received Orders Screen */
class ReceivedOrdersScreen extends StatefulWidget {
  const ReceivedOrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/cafetaria/restaurant/received_orders';

  @override
  State<ReceivedOrdersScreen> createState() => _ReceivedOrdersScreenState();
}

class _ReceivedOrdersScreenState extends State<ReceivedOrdersScreen> {
  Future<void> _refreshItems(BuildContext context) async {
    setState(() {
      Provider.of<RestaurantProvider>(context, listen: false)
          .getReceivedOrders();
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<MenuItemProvider>(context, listen: false).fetchMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Cafetaria",
        context: context,
        subtitle: "Received Orders",
      ),
      body: FutureBuilder(
        future: Provider.of<RestaurantProvider>(context, listen: false)
            .getReceivedOrders(),
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
            return Consumer2<RestaurantProvider, MenuItemProvider>(
              builder: (ctx, restaurantProvider, menuData, child) =>
                  RefreshIndicator(
                onRefresh: () => _refreshItems(context),
                child: SizedBox(
                  height: ScreenSize.usableHeight(context),
                  child: ListView.builder(
                    /* Card to render Order Items */
                    itemBuilder: (ctx, i) => RestaurantReceivedOrdersCard(
                      order: restaurantProvider.receivedOrders[i],
                      menu: menuData.items,
                      index: i,
                      setStateFunc: () {
                        setState(() {});
                      },
                    ),
                    itemCount: restaurantProvider.receivedOrders.length,
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
