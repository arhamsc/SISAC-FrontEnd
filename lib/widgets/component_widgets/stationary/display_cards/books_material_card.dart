import 'package:flutter/material.dart';

import '../../../../providers/stationary/books_material_providers.dart';

import '../../../../screens/other_screens/stationary_screens/updation_screens/add_edit_book_screen.dart';

import '../../../../widgets/ui_widgets/cards/item_card_v2.dart';

class BooksMaterialCard extends StatefulWidget {
  const BooksMaterialCard(
      {Key? key,
      required this.booksMaterial,
      required this.setStateFunc,
      required this.vendor})
      : super(key: key);

  final BooksMaterial booksMaterial;
  final Function setStateFunc;
  final bool vendor;
  @override
  _BooksMaterialCardState createState() => _BooksMaterialCardState();
}

class _BooksMaterialCardState extends State<BooksMaterialCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Center(
          child: ItemCardV2(
            imageUrl: widget.booksMaterial.imageUrl,
            itemName: widget.booksMaterial.name,
            subtitles: [
              widget.booksMaterial.author,
              "Edition: ${widget.booksMaterial.edition}",
              "Price: \u{20B9} ${widget.booksMaterial.price}",
            ],
            buttonsRequired: widget.vendor,
            buttonFunction: widget.vendor
                ? () {
                    Navigator.of(context).pushNamed(
                        AddEditStationaryItemScreen.routeName,
                        arguments: widget.booksMaterial.id);
                  }
                : null,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
