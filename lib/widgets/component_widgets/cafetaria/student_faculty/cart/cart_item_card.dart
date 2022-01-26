import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';

import '../../../../../providers/cafetaria/cafataria_providers.dart';
import '../../../../../providers/cafetaria/cart_provider.dart';

import '../../../../../utils/general/screen_size.dart';
import '../../../../../utils/general/customColor.dart';
import '../../../../../utils/general/themes.dart';

class CartItemCard extends StatefulWidget {
  const CartItemCard({
    Key? key,
    required this.menuItem,
    required this.amount,
    required this.qty,
  }) : super(key: key);

  final MenuItem menuItem;
  final int qty;
  final int amount;

  @override
  _CartItemCardState createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  TextEditingController qtyController = TextEditingController();
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    final cartP = Provider.of<CartProvider>(context, listen: false);
    return Column(
      key: ValueKey(widget.menuItem.id),
      children: [
        const SizedBox(height: 10),
        Center(
          child: Container(
            height: ScreenSize.screenHeight(context) * .14,
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
                Container(
                  width: ScreenSize.screenWidth(context) * .25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(widget.menuItem.imageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  child: Expanded(
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
                                    Text(
                                      widget.menuItem.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Amount: ${widget.amount}"),
                                      ],
                                    ),
                                    Text("Quantity: ${widget.qty}"),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: ElegantNumberButton(
                          initialValue: widget.qty,
                          minValue: 0,
                          maxValue: 5,
                          onChanged: (num) {
                            setState(
                              () {
                                cartP.updateQuantity(
                                  widget.menuItem.id,
                                  widget.menuItem.price,
                                  num.toInt(),
                                );
                              },
                            );
                          },
                          decimalPlaces: 0,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: ScreenSize.screenHeight(context) * .03,
                        width: ScreenSize.screenWidth(context) * .19,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              cartP.deleteCartItem(
                                widget.menuItem.id,
                                widget.menuItem.price,
                                deleteWhole: true,
                              );
                            });
                          },
                          child: const Text("Delete"),
                          style: ButtonThemes.elevatedButtonSmall.copyWith(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
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
