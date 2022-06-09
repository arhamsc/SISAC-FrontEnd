import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/cafetaria/cafetaria_providers.dart' as CartP;

import '../../../../../widgets/ui_widgets/cards/item_card.dart';

import '../../../../../../utils/general/customColor.dart';
import '../../../../../utils/helpers/error_dialog.dart';
import '../../../../../utils/helpers/http_exception.dart';
import '../../../../../utils/helpers/loader.dart';

/* Cafetaria - Card to view and rate a menu item */
class RatingCard extends StatefulWidget {
  const RatingCard({Key? key, required this.menu, required this.setStateFunc})
      : super(key: key);

  final CartP.MenuItem menu;
  final Function setStateFunc;

  @override
  _RatingCardState createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  /* Getter to get the current rating */
  num get rating {
    return widget.menu.rating;
  }

  bool _isLoading = false;

  late num newRating;
  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.key,
      children: [
        const SizedBox(height: 10),
        Center(
          //Custom Item Card widget
          child: ItemCard(
            imageUrl: widget.menu.imageUrl,
            itemName: widget.menu.name,
            leftSubtitle: "Ratings: ${widget.menu.rating}",
            rightSubtitle: "Price: \u{20B9} ${widget.menu.price}",
            showTwoButtons: false,
            buttonOneText: "Rate Now",
            expandedButtonOneText: "Close",
            buttonOneFunction: () {},
            expanded: true,
            expandedChildTitle: "Rate",
            expandedChild: [
              //Animated Container or base container elements
              Center(
                child: RatingBar(
                  ratingWidget: RatingWidget(
                    full: const Icon(
                      Icons.star_outlined,
                      color: Palette.quinaryDefault,
                    ),
                    half: const Icon(
                      Icons.star_half,
                      color: Palette.quinaryDefault,
                    ),
                    empty: const Icon(
                      Icons.star_border,
                      color: Palette.quinaryDefault,
                    ),
                  ),
                  initialRating: rating.toDouble(),
                  //update current rating
                  onRatingUpdate: (rat) async {
                    setState(
                      () {
                        newRating = rat;
                      },
                    );
                  },
                  allowHalfRating: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<CartP.MenuItemProvider>(
                builder: (ctx, menuData, _) => ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 30,
                          ),
                        ),
                      ),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      /* Update rating functions */
                      await menuData.updateRating(widget.menu.id, newRating);
                      await dialog(
                        ctx: context,
                        errorMessage: "Thank you for rating",
                        title: "Success",
                      );
                      setState(() {
                        _isLoading = false;
                      });
                    } on HttpException catch (error) {
                      await dialog(ctx: context, errorMessage: error.message);
                      setState(() {
                        _isLoading = false;
                      });
                    }
                    widget.setStateFunc();
                  },
                  child: _isLoading
                      ? SISACLoader(
                          size: 40,
                        )
                      : const Text(
                          "Rate",
                        ),
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
