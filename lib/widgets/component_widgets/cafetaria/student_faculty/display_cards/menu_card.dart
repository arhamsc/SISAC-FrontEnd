import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../providers/cafetaria/cafetaria_providers.dart';
import '../../../../../providers/cafetaria/cart_provider.dart';

import '../../../../ui_widgets/cards/item_card.dart';

import '../../../../extra/badge.dart';

import '../../../../../utils/helpers/snack_bar.dart';

/* Cafetaria - Card widget to display the menu items and add to cart functionality */
class MenuCard extends StatefulWidget {
  const MenuCard({
    Key? key,
    required this.menu,
    required this.preOrder,
    required this.showBadge,
  }) : super(key: key);

  final MenuItem menu;
  final bool preOrder;
  final bool showBadge;
  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    final cartP = Provider.of<CartProvider>(context, listen: false);
    Widget mainCard = Column(
      children: [
        const SizedBox(height: 10),
        Center(
          //Custom Item Card widget
          child: ItemCard(
            imageUrl: widget.menu.imageUrl,
            itemName: widget.menu.name,
            leftSubtitle: "Ratings: ${widget.menu.rating}",
            rightSubtitle: "Price: \u{20B9} ${widget.menu.price}",
            showTwoButtons: true,
            buttonOneText: "View More",
            expandedButtonOneText: "View Less",
            buttonOneFunction: () {},
            expanded: true,
            buttonTwoText: "Add to Cart",
            /* Add to Cart Function */
            buttonTwoFunction: widget.menu.isAvailable && widget.preOrder
                ? () {
                    cartP.addCartItem(
                      widget.menu.id,
                      cartP
                          .getItemPrice(
                            widget.menu.price,
                            1,
                          )
                          .toInt(),
                      1,
                    );
                    customSnackBar(
                      ctx: context,
                      title: '${widget.menu.name} added to the cart',
                      undoFunc: () => cartP.deleteCartItem(
                        widget.menu.id,
                        widget.menu.price,
                      ),
                    );
                  }
                : () {
                    customSnackBar(
                      ctx: context,
                      title: 'Item not available',
                      undoFunc: () {},
                      error: true,
                    );
                  },
            showSecondaryButtonTwoColor:
                widget.menu.isAvailable && widget.preOrder,
            expandedChildTitle: "Description",
            expandedChild: [
              Text(widget.menu.description),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
    //Returning the menu card based on popular dish
    return widget.showBadge ? Badge(child: mainCard) : mainCard;
  }
}
