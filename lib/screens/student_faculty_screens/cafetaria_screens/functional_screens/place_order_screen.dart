import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisac/utils/helpers/error_dialog.dart';

import '../../../../providers/cafetaria/order_providers.dart';

import '../../../../widgets/component_widgets/scaffold/app_bar.dart';
import '../../../../widgets/component_widgets/cafetaria/bottom_nav.dart';

import '../../../../utils/general/customColor.dart';
import '../../../../utils/general/screen_size.dart';
import '../../../../utils/helpers/http_exception.dart';

class PlaceOrderScreen extends StatefulWidget {
  static const routeName = '/cafetaria/placeOrder';
  const PlaceOrderScreen({Key? key}) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  TextEditingController qtyController = TextEditingController();
  int quantity = 1;

  bool _isLoading = false;

  //to generate random string ********
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  //End********* */

  @override
  void didChangeDependencies() {
    qtyController.addListener(() {
      quantity = int.parse(qtyController.text);
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    qtyController.removeListener(() {});
    qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;

    Future<void> _postOrder() async {
      setState(() {
        _isLoading = true;
      });
      try {
        setState(() {
          _isLoading = false;
          Navigator.of(context).pop();
        });
        await dialog(
            ctx: context, errorMessage: "Order Placed", title: "Success");
      } on HttpException catch (error) {
        await dialog(ctx: context, errorMessage: error.message);
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
      appBar: BaseAppBar.getAppBar(
        title: "Cafetaria",
        context: context,
        subtitle: "Placing Order",
      ),
      body: SingleChildScrollView(
        child: Container(
          height: ScreenSize.screenHeight(context) -
              AppBar().preferredSize.height -
              61,
          child: Column(
            children: [
              Container(
                height: ScreenSize.usableHeight(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                            arguments['name'],
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: Palette.tertiaryDefault,
                                      fontSize: 30,
                                    ),
                          ),
                          Text(
                            'Price: ${arguments['price'].toString()}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Quantity:",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: SecondaryPallete.tertiary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: 50,
                            height: 30,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: qtyController,
                              decoration: const InputDecoration(
                                fillColor: Palette.tertiaryDefault,
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                color: Palette.tertiaryDefault,
                              ),
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: ScreenSize.screenWidth(context) * .6,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: _postOrder,
                              child: Text(
                                "Proceed to pay",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 40,
                                ),
                                primary: Palette.quaternaryDefault,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Cancel",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 40,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
              Expanded(
                child: BottomNav(
                  isSelected: "Cafetaria",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
