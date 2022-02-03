import 'package:flutter/material.dart';

import '../../../../providers/stationary/material_available_providers.dart';

import '../../../../screens/other_screens/stationary_screens/updation_screens/add_edit_material_available_screen.dart';

import '../../../../widgets/ui_widgets/cards/item_card_v2.dart';

/* Stationary - Material Card */
class MaterialAvailableCard extends StatefulWidget {
  const MaterialAvailableCard({
    Key? key,
    required this.materialAvailable,
    required this.setStateFunc,
    required this.vendor,
    this.deleteFunction,
  }) : super(key: key);

  final MaterialAvailable materialAvailable;
  final Function setStateFunc;
  final bool vendor;
  final Function? deleteFunction;
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
          //Custom Item card
          child: ItemCardV2(
            imageUrl: widget.materialAvailable.imageUrl,
            itemName: widget.materialAvailable.name,
            subtitles: [
              "Price: \u{20B9} ${widget.materialAvailable.price}",
            ],
            largerItemName: true,
            extraHeight: false,
            buttonsRequired: widget.vendor,
            buttonFunction: widget.vendor
                ? () {
                    Navigator.of(context).pushNamed(
                      AddEditMaterialAvailableScreen.routeName,
                      arguments: widget.materialAvailable.id,
                    );
                  }
                : null,
            showDeleteButton: widget.vendor,
            deleteButtonFunction: () {
              widget.deleteFunction != null ? widget.deleteFunction!() : null;
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
