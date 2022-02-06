import 'package:flutter/material.dart';
import 'package:sisac/utils/helpers/http_exception.dart';
import 'package:provider/provider.dart';

import '../../../../providers/cafetaria/cafetaria_providers.dart';
import '../../../../providers/cafetaria/restaurant_providers.dart';

import '../../../../utils/general/screen_size.dart';
import '../../../../utils/general/customColor.dart';

/* Restaurant - Received Orders card to View and Delete Orders */
class RestaurantReceivedOrdersCard extends StatefulWidget {
  const RestaurantReceivedOrdersCard({
    Key? key,
    required this.menu,
    required this.order,
    required this.index,
    required this.setStateFunc,
    required this.deleteOrder,
  }) : super(key: key);

  final List<MenuItem> menu;
  final ReceivedOrder order;
  final int index;
  final Function setStateFunc;
  final Function deleteOrder;

  @override
  _RestaurantReceivedOrdersCardState createState() =>
      _RestaurantReceivedOrdersCardState();
}

class _RestaurantReceivedOrdersCardState
    extends State<RestaurantReceivedOrdersCard> {
  var _expanded = false;

  // Getter to get menu item image
  String get dishImage {
    return widget.order.menuOrders[widget.index].items.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Center(
          child: Stack(
            children: [
              /* Base Container to view the Order Items and Delete Button */
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: _expanded ? ScreenSize.screenHeight(context) * .4 : 0,
                width: ScreenSize.screenWidth(context) * .85,
                decoration: BoxDecoration(
                  color: Palette.senaryDefault,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //To view the Order Items
                                    Text(
                                      "${index + 1}. ${widget.order.menuOrders[index].items.name}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(fontSize: 15),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Text(
                                      "Quantity: ${widget.order.menuOrders[index].quantity}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              itemCount: widget.order.menuOrders.length,
                            ),
                            const SizedBox(height: 20),
                            //Button toe delete the order
                            ElevatedButton(
                              onPressed: () async {
                                widget.deleteOrder();
                                widget.setStateFunc();
                              },
                              child: const Text('Prepared'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //Display the above card for order overview
              Container(
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
                  ],
                ),
                child: Row(
                  children: [
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
                          //Display total items in particular order
                          Text(
                            "Total Items: ${widget.order.menuOrders.length}",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          //Display username
                          Text(
                            widget.order.user.username,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 15),
                          ),
                          //Display the person's name
                          Text(
                            widget.order.user.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 15),
                          ),
                          //Display payment status
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
                    //To display the Expand Button
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Container(
                          decoration: BoxDecoration(
                            color: Palette.quaternaryDefault,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: ScreenSize.screenHeight(context) * 0.04,
                          width: ScreenSize.screenWidth(context) * .08,
                          child: Center(
                              child: IconButton(
                            padding: const EdgeInsets.all(0),
                            color: Palette.quinaryDefault,
                            icon: _expanded
                                ? const Icon(Icons.arrow_drop_up)
                                : const Icon(Icons.arrow_drop_down),
                            onPressed: () async {
                              //toggle expanded boolean
                              setState(() {
                                _expanded = !_expanded;
                              });
                            },
                            splashRadius: 1,
                          )),
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
            ],
          ),
        ),
      ],
    );
  }
}
