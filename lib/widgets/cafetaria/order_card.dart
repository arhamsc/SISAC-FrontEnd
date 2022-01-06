import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../providers/cafetaria/order_providers.dart';

import '../../screens/student_faculty_screens/cafetaria_screens/place_order_screen.dart';

import '../../../utils/general/screen_size.dart';
import '../../../utils/general/customColor.dart';
import '../../../utils/general/themes.dart';

class OrderCard extends StatefulWidget {
  OrderCard({Key? key, required this.order, required this.orderNum})
      : super(key: key);

  final Order order;
  final int orderNum;

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Center(
          child: Container(
            height: ScreenSize.screenHeight(context) * .108,
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Order: ${(widget.orderNum + 1).toString()}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Quantity: ${widget.order.menuOrders[widget.orderNum].quantity}"),
                                      Text(
                                          "Price: ${widget.order.menuOrders[widget.orderNum].itemPrice}"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10)
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Center(
                            child: Text(
                              "Ordered On: ${DateFormat('dd-MM-yyyy').format(widget.order.createdOn)}",
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Palette.quaternaryDefault,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 20,
                                ),
                                child: Text(
                                  "Total Amount: ${widget.order.totalAmount}",
                                ),
                              ),
                            ),
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
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
