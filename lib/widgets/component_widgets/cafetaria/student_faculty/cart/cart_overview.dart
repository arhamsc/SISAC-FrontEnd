import 'package:flutter/material.dart';

import '../../../../../utils/general/customColor.dart';
import '../../../../../utils/general/screen_size.dart';

/* Cafetaria - Cart Overview Card to display overall cart amount/no of items and placing order */
class CartOverViewCard extends StatefulWidget {
  const CartOverViewCard({
    Key? key,
    required this.totalAmount,
    required this.totalItems,
    required this.submitOrder,
    required this.isLoading,
  }) : super(key: key);
  final int totalAmount;
  final int totalItems;
  final Future<void> Function() submitOrder;
  final bool isLoading;

  @override
  State<CartOverViewCard> createState() => _CartOverViewCardState();
}

class _CartOverViewCardState extends State<CartOverViewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.screenHeight(context) * 0.15,
      width: ScreenSize.screenWidth(context) * .9,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    //Subtotal - Overall cart amount
                    TextSpan(
                      text: 'Subtotal',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: '  \u{20B9} ${widget.totalAmount}\u2070\u2070',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    //Total number of items
                    TextSpan(
                      text: 'Items',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: '  ${widget.totalItems}',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //Button to submit the Order
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.submitOrder();
              });
            },
            child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                : const Text("Proceed to Buy"),
          ),
        ],
      ),
    );
  }
}
