import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisac/utils/helpers/http_exception.dart';

import '../../../../providers/cafetaria/cafetaria_providers.dart' as CafeP;
import '../../../../providers/cafetaria/cart_provider.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/cafetaria/student_faculty/cart/cart_overview.dart';
import '../../../../widgets/component_widgets/cafetaria/student_faculty/cart/cart_item_card.dart';

import '../../../../utils/general/screen_size.dart';
import '../../../../utils/helpers/error_dialog.dart';
import '../../../../utils/helpers/confirmation_dialog.dart';

/* Cafetaria - Cart Screen */
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

    /* Function to find a Menu Item By Id */
    CafeP.MenuItem findMenuItem(String id) {
      final menuP = Provider.of<CafeP.MenuItemProvider>(context, listen: false);
      final item = menuP.items.firstWhere((element) => element.id == id);
      return item;
    }

    final cartP = Provider.of<CartProvider>(context);

    /* Function to place an Order */
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

    /* Show Confirmation Dialog */
    Future<void> _showOrderDialog(num amt) async {
      return showDialog(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            title: "Placing the Order!",
            content: "Total amount: $amt, Do you confirm?",
            confirmationFunction: () => _placeOrder(),
          );
        },
      );
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
            //Cart Overview Widget
            CartOverViewCard(
              totalAmount: cartP.totalAmount,
              totalItems: cartP.totalItems,
              submitOrder: () => _showOrderDialog(cartP.totalAmount),
              isLoading: _isLoading,
            ),
            const SizedBox(height: 10),
            //Cart Items Display Widget
            cartP.cartItems.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        "No Cart Items",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: SizedBox(
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
