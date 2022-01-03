import 'package:flutter/material.dart';
import 'package:sisac/utils/helpers/http_exception.dart';
import 'package:provider/provider.dart';

import '../../../providers/cafetaria/cafataria_providers.dart';
import '../../../providers/cafetaria/restaurant_providers.dart';

import '../../../utils/general/screen_size.dart';
import '../../../utils/general/customColor.dart';

import '../../../utils/helpers/error_dialog.dart';

class RestaurantReceivedOrdersCard extends StatefulWidget {
  RestaurantReceivedOrdersCard(
      {Key? key,
      required this.menu,
      required this.order,
      required this.index,
      required this.setStateFunc})
      : super(key: key);

  final List<MenuItem> menu;
  final ReceivedOrder order;
  final int index;
  final Function setStateFunc;

  @override
  _RestaurantReceivedOrdersCardState createState() =>
      _RestaurantReceivedOrdersCardState();
}

class _RestaurantReceivedOrdersCardState
    extends State<RestaurantReceivedOrdersCard> {
  var _expanded = false;

  MenuItem get dish {
    return widget.menu.firstWhere((element) =>
        element.id == widget.order.menuOrders[widget.index].itemId);
  }

  String dishName(String id) {
    var name;
    widget.menu.forEach((element) {
      element.id == id ? name = element.name : null;
    });
    return name;
  }

  String get menuName {
    return dishName(dish.id);
  }

  bool _isLoading = false;

  Future<void> deleteOrder(RestaurantProvider rest, String id) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var res = await rest.deleteOrder(id);
      await dialog(
          ctx: context, errorMessage: "Order Completed", title: "Success");
      await rest.getReceivedOrders();
      setState(() {
        _isLoading = false;
      });
    } on HttpException catch (error) {
      await dialog(ctx: context, errorMessage: error.message, title: "Success");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final restP = Provider.of<RestaurantProvider>(context);
    return Column(
      children: [
        const SizedBox(height: 25),
        Center(
          child: Container(
            height: ScreenSize.screenHeight(context) * .12,
            width: ScreenSize.screenWidth(context) * .85,
            decoration: BoxDecoration(
                color: SecondaryPallete.primary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black54,
                    spreadRadius: 2,
                    offset: Offset(0, -2),
                  ),
                ]),
            child: Row(
              children: [
                Container(
                  width: ScreenSize.screenWidth(context) * .25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(dish.imageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        menuName,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.order.user.username,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 15),
                      ),
                      Text(
                        widget.order.user.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 15),
                      ),
                      Text(
                        widget.order.paymentStatus,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Container(
                      decoration: BoxDecoration(
                          color: Palette.quaternaryDefault,
                          borderRadius: BorderRadius.circular(10)),
                      height: ScreenSize.screenHeight(context) * 0.04,
                      width: ScreenSize.screenWidth(context) * .08,
                      child: Center(
                        child: !_isLoading
                            ? IconButton(
                                padding: const EdgeInsets.all(0),
                                color: Palette.quinaryDefault,
                                icon: Icon(Icons.check),
                                onPressed: () async {
                                  await deleteOrder(restP, widget.order.id);
                                  widget.setStateFunc();
                                },
                                splashRadius: 1,
                              )
                            : CircularProgressIndicator(),
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
