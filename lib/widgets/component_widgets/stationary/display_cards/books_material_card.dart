import 'package:flutter/material.dart';

import '../../../../providers/stationary/books_material_providers.dart';

import '../../../../../utils/general/screen_size.dart';
import '../../../../../utils/general/customColor.dart';
import '../../../../../utils/general/themes.dart';

class BooksMaterialCard extends StatefulWidget {
  BooksMaterialCard(
      {Key? key, required this.booksMaterial, required this.setStateFunc})
      : super(key: key);

  final BooksMaterial booksMaterial;
  final Function setStateFunc;

  @override
  _BooksMaterialCardState createState() => _BooksMaterialCardState();
}

class _BooksMaterialCardState extends State<BooksMaterialCard> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
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
                      image: NetworkImage(widget.booksMaterial.imageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
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
                                      widget.booksMaterial.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                    ),
                                    Text(
                                      widget.booksMaterial.author,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Edition: ${widget.booksMaterial.edition}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Price: ${widget.booksMaterial.price.toString()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10)
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
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
