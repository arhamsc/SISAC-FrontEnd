import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/cafetaria/order_providers.dart';
import '../../../../providers/cafetaria/cafetaria_providers.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/scaffold/bottom_nav.dart';
import '../../../../widgets/component_widgets/cafetaria/student_faculty/display_cards/order_card.dart';

import '../../../../utils/helpers/error_dialog.dart';
import '../../../../utils/general/screen_size.dart';

/* Cafetaria - Screen to View individual User Orders */
class OrderScreen extends StatefulWidget {
  static const routeName = '/cafetaria/orders';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  /* Pull to Refresh Function */
  Future<void> _refreshItems(BuildContext context) async {
    setState(() {
      Provider.of<OrderProvider>(context, listen: false).fetchUserOrders();
    });
  }

  @override
  void initState() {
    super.initState();
    () async {
      await Future.delayed(Duration.zero, () async {
        final menuP = Provider.of<MenuItemProvider>(context, listen: false);
        await menuP.fetchMenu();
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final pageController =
        ModalRoute.of(context)?.settings.arguments as PageController;
    return Scaffold(
      appBar: BaseAppBar.getAppBar(
          title: "Cafetaria", context: context, subtitle: "Orders"),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false)
            .fetchUserOrders(),
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
            return Consumer<OrderProvider>(
              builder: (ctx, orderData, child) => RefreshIndicator(
                onRefresh: () => _refreshItems(context),
                child: SizedBox(
                  height: ScreenSize.usableHeight(context),
                  child: ListView.builder(
                    itemBuilder: (ctx, i) =>
                    /* Card to Render Orders */
                        OrderCard(order: orderData.userOrders[i], orderNum: i),
                    itemCount: orderData.userOrders.length,
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
