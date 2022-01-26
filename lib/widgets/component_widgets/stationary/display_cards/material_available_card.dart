import 'package:flutter/material.dart';

import '../../../../providers/stationary/material_available_providers.dart';

import '../../../../widgets/ui_widgets/cards/item_card_v2.dart';

class MaterialAvailableCard extends StatefulWidget {
  const MaterialAvailableCard({
    Key? key,
    required this.materialAvailable,
    required this.setStateFunc,
  }) : super(key: key);

  final MaterialAvailable materialAvailable;
  final Function setStateFunc;

  @override
  _MaterialAvailableCardState createState() => _MaterialAvailableCardState();
}

class _MaterialAvailableCardState extends State<MaterialAvailableCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Center(
          child: ItemCardV2(
            imageUrl: widget.materialAvailable.imageUrl,
            itemName: widget.materialAvailable.name,
            subtitles: [
              "Price: \u{20B9} ${widget.materialAvailable.price}",
            ],
            largerItemName: true,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
