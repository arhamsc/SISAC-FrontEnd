import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../providers/cafetaria/order_providers.dart';

import '../../../../../../utils/general/screen_size.dart';
import '../../../../../../utils/general/customColor.dart';

/* Cafetaria - Individual order card  */
class OrderCard extends StatefulWidget {
  const OrderCard({Key? key, required this.order, required this.orderNum})
      : super(key: key);

  final Order order;
  final int orderNum;

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  //toggle the animated container
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Center(
          child: Stack(
            children: [
              //Container to view the order items in a particular order
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
                            Text(
                              "Order Items",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "${index + 1}. ${widget.order.menuOrders[index].items.name}, Quantity: ${widget.order.menuOrders[index].quantity}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 15),
                                ),
                              ),
                              itemCount: widget.order.menuOrders.length,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //View overall order details
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
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //Order Number
                                          Text(
                                            "Order: ${(widget.orderNum + 1).toString()}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          //Total Order Amount
                                          Text(
                                            "\u{20B9} ${(widget.order.totalAmount).toString()}\u2070\u2070",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10)
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Center(
                                //Payment Status
                                child: Text(
                                  "Payment: ${widget.order.paymentStatus}",
                                ),
                              ),
                              SizedBox(
                                height: ScreenSize.screenHeight(context) * .008,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Palette.quaternaryDefault,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: ScreenSize.screenWidth(context) * .6,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 20,
                                        ),
                                        //Order Date
                                        child: Text(
                                          "Ordered On: ${DateFormat('dd-MM-yyyy - kk:mm').format(widget.order.createdOn)}",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Palette.quaternaryDefault,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: ScreenSize.screenHeight(context) *
                                        0.035,
                                    width:
                                        ScreenSize.screenWidth(context) * .08,
                                    //Toggle expanded state
                                    child: IconButton(
                                      padding: const EdgeInsets.all(0),
                                      color: Palette.quinaryDefault,
                                      icon: _expanded
                                          ? const Icon(Icons.arrow_drop_up)
                                          : const Icon(Icons.arrow_drop_down),
                                      onPressed: () async {
                                        setState(() {
                                          _expanded = !_expanded;
                                        });
                                      },
                                      splashRadius: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
