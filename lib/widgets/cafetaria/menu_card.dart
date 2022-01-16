import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cafetaria/cafataria_providers.dart';
import '../../providers/cafetaria/cart_provider.dart';

import '../../../utils/general/screen_size.dart';
import '../../../utils/general/customColor.dart';
import '../../../utils/general/themes.dart';

import '../../utils/helpers/snack_bar.dart';

class MenuCard extends StatefulWidget {
  MenuCard({Key? key, required this.menu}) : super(key: key);

  final MenuItem menu;

  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    final cartP = Provider.of<CartProvider>(context, listen: false);
    return Column(
      children: [
        const SizedBox(height: 10),
        Center(
          child: Stack(
            children: [
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
                              "Description",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            Text(widget.menu.description),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
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
                child: Row(
                  children: [
                    Container(
                      width: ScreenSize.screenWidth(context) * .25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(widget.menu.imageUrl),
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
                                          widget.menu.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "Ratings: ${widget.menu.rating.toString()}"),
                                            Text("Price: ${widget.menu.price}"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height:
                                        ScreenSize.screenHeight(context) * .02,
                                    width:
                                        ScreenSize.screenWidth(context) * .22,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Navigator.pushNamed(
                                        //   context,
                                        //   PlaceOrderScreen.routeName,
                                        //   arguments: {
                                        //     'name': widget.menu.name,
                                        //     'price': widget.menu.price,
                                        //     'menu': widget.menu,
                                        //   },
                                        // );
                                        cartP.addCartItem(
                                          widget.menu.id,
                                          cartP
                                              .getItemPrice(
                                                  widget.menu.price, 1)
                                              .toInt(),
                                          1,
                                        );
                                        customSnackBar(
                                          ctx: context,
                                          title:
                                              '${widget.menu.name} added to the cart',
                                          undoFunc: () => cartP
                                              .deleteCartItem(widget.menu.id, widget.menu.price),
                                        );
                                      },
                                      child: const Text(
                                        "Add to Cart",
                                        softWrap: false,
                                      ),
                                      style: ButtonThemes.elevatedButtonSmall
                                          .copyWith(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Palette.quaternaryDefault,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    height:
                                        ScreenSize.screenHeight(context) * .02,
                                    width:
                                        ScreenSize.screenWidth(context) * .177,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _expanded = !_expanded;
                                        });
                                      },
                                      child: !_expanded
                                          ? const Text(
                                              "View More",
                                              softWrap: false,
                                            )
                                          : const Text(
                                              "View Less",
                                              softWrap: false,
                                            ),
                                      style: ButtonThemes.elevatedButtonSmall
                                          .copyWith(
                                        padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
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
