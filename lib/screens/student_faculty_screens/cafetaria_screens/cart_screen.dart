import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisac/utils/helpers/http_exception.dart';

import '../../../providers/cafetaria/cafataria_providers.dart';
import '../../../providers/cafetaria/cart_provider.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/cafetaria/bottom_nav.dart';
import '../../../widgets/cafetaria/cart/cart_overview.dart';
import '../../../widgets/cafetaria/cart/cart_item_card.dart';

import '../../../utils/general/screen_size.dart';
import '../../../utils/helpers/error_dialog.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cafetaria/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;

    //to generate random string ********
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) => String.fromCharCodes(
          Iterable.generate(
            length,
            (_) => _chars.codeUnitAt(
              _rnd.nextInt(_chars.length),
            ),
          ),
        );
    //End********* */

    MenuItem findMenuItem(String id) {
      final menuP = Provider.of<MenuItemProvider>(context, listen: false);
      final item = menuP.items.firstWhere((element) => element.id == id);
      return item;
    }

    final cartP = Provider.of<CartProvider>(context);

    Future<void> _placeOrder() async {
      _isLoading = true;
      try {
        await cartP.makeOrder(
          cartP.cartItems.values.toList(),
          cartP.totalAmount,
          'Completed',
          getRandomString(10),
          DateTime.now().toString(),
        );
        _isLoading = false;
        await dialog(
          ctx: context,
          errorMessage: "Order Placed",
          title: "Success",
        );
      } on HttpException catch (error) {
        await dialog(ctx: context, errorMessage: error.message);

        _isLoading = false;
      }
    }

    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: 'Cafetaria',
        context: context,
        subtitle: 'Cart',
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            CartOverViewCard(
              totalAmount: cartP.totalAmount,
              totalItems: cartP.totalItems,
              submitOrder: _placeOrder,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 10),
            cartP.cartItems.isEmpty
                ? const Center(
                    child: Text("No Cart Items"),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        height: ScreenSize.screenHeight(context) * .6,
                        child: ListView.builder(
                          itemBuilder: (ctx, index) => CartItemCard(
                            menuItem: findMenuItem(
                              cartP.cartItems.values.toList()[index].itemId,
                            ),
                            qty:
                                cartP.cartItems.values.toList()[index].quantity,
                            amount: cartP.cartItems.values
                                .toList()[index]
                                .itemPrice,
                          ),
                          itemCount: cartP.cartItems.length,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
