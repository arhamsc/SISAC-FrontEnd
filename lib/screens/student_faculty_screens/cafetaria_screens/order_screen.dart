import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cafetaria/order_providers.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/cafetaria/bottom_nav.dart';
import '../../../widgets/cafetaria/order_card.dart';

import '../../../utils/helpers/error_dialog.dart';
import '../../../utils/general/screen_size.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/cafetaria/orders';
  const OrderScreen({Key? key}) : super(key: key);

  Future<void> _refreshItems(BuildContext context) async {
    return await Provider.of<OrderProvider>(context, listen: false)
        .fetchUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    //final orderP = Provider.of<OrderProvider>(context);
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
            return RefreshIndicator(
              onRefresh: () => _refreshItems(context),
              child: Column(
                children: [
                  Consumer<OrderProvider>(
                    builder: (ctx, orderData, child) => Container(
                      child: SingleChildScrollView(
                        child: Container(
                          height: ScreenSize.usableHeight(context),
                          child: ListView.builder(
                            itemBuilder: (ctx, i) => OrderCard(
                                order: orderData.userOrders[i], orderNum: i),
                            itemCount: orderData.userOrders.length,
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
