import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sisac/utils/helpers/error_dialog.dart';
import 'package:sisac/utils/helpers/http_exception.dart';

import '../../providers/cafetaria/cafataria_providers.dart';

import '../../../utils/general/screen_size.dart';
import '../../../utils/general/customColor.dart';
import '../../../utils/general/themes.dart';

class RatingCard extends StatefulWidget {
  RatingCard({Key? key, required this.menu, required this.setStateFunc})
      : super(key: key);

  final MenuItem menu;
  final Function setStateFunc;

  @override
  _RatingCardState createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  var _expanded = false;
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
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: _expanded ? ScreenSize.screenHeight(context) * .3 : 0,
                width: ScreenSize.screenWidth(context) * .85,
                decoration: BoxDecoration(
                  color: Palette.senaryDefault,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            Consumer<MenuItemProvider>(
                              builder: (ctx, menuData, _) => ElevatedButton(
                                style: Theme.of(context)
                                    .elevatedButtonTheme
                                    .style!
                                    .copyWith(
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
                                    await menuData.updateRating(
                                        widget.menu.id, newRating);
                                    await dialog(
                                        ctx: context,
                                        errorMessage: "Thank you for rating",
                                        title: "Success");
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } on HttpException catch (error) {
                                    await dialog(
                                        ctx: context,
                                        errorMessage: error.message);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                  widget.setStateFunc();
                                },
                                child: _isLoading
                                    ? CircularProgressIndicator()
                                    : const Text(
                                        "Rate",
                                      ),
                              ),
                            ),
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
                    ]),
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
                                                "Ratings: ${widget.menu.rating.toStringAsPrecision(2)}"),
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
                                  const SizedBox(width: 10),
                                  Container(
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
                                              "Rate Now",
                                              softWrap: false,
                                            )
                                          : const Text(
                                              "Close",
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
